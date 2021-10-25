require "net/http"
require "uri"
require "json"

class PostsGenerator::Group::Meetup < PostsGenerator::Group
  private

  def events
    @events ||= source_data
      .select { |event_data|
        event_data["confirmCount"] > 1 && (
          @group["meetup_filter"].nil? || event_data["title"].include?(@group["meetup_filter"]["title_includes"])
        )
      }
      .collect { |event_data|
      Event.new(
        title: event_data["title"],
        datetime: Time.parse(event_data["servertime"]),
        url: event_data["event_url"],
        online_event: event_data["venue_name"] == "Online event",
        name: name
      )
    }
  end

  def meetup_id
    @group["meetup_id"]
  end

  def source_data
    json_string = Net::HTTP.get(URI.parse("https://www.meetup.com/#{meetup_id}/events/json/"))
    begin
      @source_data ||= JSON.parse(json_string)
    rescue JSON::ParserError
      puts "Invalid JSON"
    end
  end
end
