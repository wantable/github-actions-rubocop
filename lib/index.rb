# frozen_string_literal: true

require 'net/http'
require 'json'
require 'time'

@GITHUB_SHA = ENV['GITHUB_SHA']
@GITHUB_EVENT_PATH = ENV['GITHUB_EVENT_PATH']
@GITHUB_TOKEN = ENV['GITHUB_TOKEN']
@GITHUB_WORKSPACE = ENV['GITHUB_WORKSPACE']

@event = JSON.parse(File.read(ENV['GITHUB_EVENT_PATH']))
@repository = @event['repository']
@owner = @repository['owner']['login']
@repo = @repository['name']

@check_name = 'HamlLint'

@headers = {
  "Content-Type": 'application/json',
  "Accept": 'application/vnd.github.v3+json',
  "Authorization": "Bearer #{@GITHUB_TOKEN}",
  "User-Agent": 'github-actions-rubocop',
  "X-GitHub-Api-Version": '2022-11-28'
}

def create_check
  body = {
    'name' => @check_name,
    'head_sha' => @GITHUB_SHA,
    'status' => 'in_progress',
    'started_at' => Time.now.iso8601
  }

  http = Net::HTTP.new('api.github.com', 443)
  http.use_ssl = true
  path = "/repos/#{@owner}/#{@repo}/check-runs"

  resp = http.post(path, body.to_json, @headers)

  raise resp.message if resp.code.to_i >= 300

  data = JSON.parse(resp.body)
  data['id']
end

def update_check(id, conclusion, output)
  body = {
    'name' => @check_name,
    'status' => 'completed',
    'completed_at' => Time.now.iso8601,
    'conclusion' => conclusion,
    'output' => output
  }

  http = Net::HTTP.new('api.github.com', 443)
  http.use_ssl = true
  path = "/repos/#{@owner}/#{@repo}/check-runs/#{id}"
  puts path.inspect
  resp = http.patch(path, body.to_json, @headers)
  parsed = JSON.parse(resp.body)
  puts parsed.keys.inspect
  puts parsed['output']['annotations_count'].inspect
  raise resp.message if resp.code.to_i >= 300
end

@annotation_levels = {
  'refactor' => 'failure',
  'convention' => 'failure',
  'warning' => 'warning',
  'error' => 'failure',
  'fatal' => 'failure'
}

def run_rubocop
  annotations = []
  errors = nil
  Dir.chdir(@GITHUB_WORKSPACE) do
    errors = JSON.parse(`haml-lint -r json`)
  end
  conclusion = 'success'
  count = 0

  errors['files'].each do |file|
    path = file['path']
    offenses = file['offenses']

    offenses.each do |offense|
      severity = offense['severity']
      message = offense['message']
      location = offense['location']
      annotation_level = @annotation_levels[severity]
      count += 1

      annotations.push(
        'path' => path,
        'start_line' => location['line'],
        'end_line' => location['line'],
        "annotation_level": annotation_level,
        'message' => message
      )
    end
  end

  conclusion = 'failure' if annotations.any? { |a| a['annotation_level'] == 'warning' }

  output = {
    "title": @check_name,
    "summary": "#{count} offense(s) found",
    'annotations': annotations
  }

  puts output['summary']
  # output[:annotations].each{|x|puts x.inspect}

  { 'output' => output, 'conclusion' => conclusion }
end

def run
  id = create_check
  begin
    results = run_rubocop
    conclusion = results['conclusion']
    output = results['output']

    # https://docs.github.com/en/rest/reference/checks#output-object
    # annotations limited to 50 per request
    output[:annotations].each_slice(40).each do |annotation_slice|
      output_dup = output.dup
      output_dup['annotations'] = annotation_slice

      update_check(id, conclusion, output_dup)
    end

    if conclusion == 'failure'
      puts output.inspect
      raise
    end
  rescue StandardError
    update_check(id, 'failure', nil)
    raise
  end
end

run
