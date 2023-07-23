require "bundler/setup"
ENV['GEM_HOME'] = "/tmp/vendor/bundle/ruby/2.7.0"
ENV['GEM_PATH'] = "/tmp/vendor/bundle/ruby/2.7.0"
require "slack"
require "uri"
require "net/http"

def get_employees(cursor = nil)
  url = "https://api.latticehq.com/v1/users?limit=100"
  url << "&startingAfter=#{cursor}" unless cursor.nil?
  url = URI(url)

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(url)
  request["Accept"] = "application/json"
  request["Authorization"] = ENV["LATTICE_API_KEY"]
  response = JSON.parse(http.request(request).read_body)
  @employees << response["data"]
  get_employees(response["endingCursor"]) if response["hasMore"]
end

def remove_ignored_users
  ignored_users = ENV["IGNORED_USERS"].split(",").map(&:strip)
  @employees.select! { |employee| !ignored_users.include?(employee["email"]) }
end

def parse_employees
  today = Date.today

  @employees.each do |employee|
    birth_date = Date.parse(employee["birthDate"]) if employee["birthDate"]
    start_date = Date.parse(employee["startDate"]) if employee["startDate"]
    @birthdays << employee["name"] if (birth_date&.day == today.day) && (birth_date&.month == today.month)
    if (start_date&.day == today.day) && (start_date&.month == today.month)
      tenure = today.year - start_date.year
      # If tenure < 0, it is their first day!
      @workaversaries << "#{employee["name"]} (#{tenure} #{(tenure == 1) ? "year" : "years"})" if tenure > 0
    end
  end
end

def post_messages
  Slack.configure do |config|
    config.token = ENV["SLACK_API_TOKEN"]
    raise "Missing ENV[SLACK_API_TOKEN]!" unless config.token
  end

  birthday_message = generate_message("birthday", @birthdays) unless @birthdays.empty?
  workaversary_message = generate_message("workaversary", @workaversaries) unless @workaversaries.empty?
  client = Slack::Web::Client.new
  client.auth_test
  client.chat_postMessage(channel: ENV["CHANNEL"], text: birthday_message, as_user: true) unless birthday_message.nil?
  client.chat_postMessage(channel: ENV["CHANNEL"], text: workaversary_message, as_user: true) unless workaversary_message.nil?
end

def generate_message(anniversary, recipients)
  recipients_count = recipients.length
  if recipients_count == 1
    "Happy #{anniversary} #{recipients[0]}! 🎉"
  elsif recipients_count == 2
    "Happy #{anniversary} to #{recipients[0]} and #{recipients[1]}! 🎉"
  else
    "Happy #{anniversary} to #{recipients[0..recipients_count - 2].join(", ")} and #{recipients[recipients_count - 1]}! 🎉"
  end
end

def lambda_handler(event: nil, context: nil)
  @employees = []
  @birthdays = []
  @workaversaries = []
  get_employees
  @employees = @employees.flatten
  remove_ignored_users if ENV["IGNORED_USERS"]
  parse_employees
  post_messages if !@birthdays.empty? || !@workaversaries.empty?
end
