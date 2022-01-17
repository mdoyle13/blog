require 'json'

data = File.read('src/_data/spotify_history.json')
streams = JSON.parse(data)

arr = []
streams.each do |stream|
  match = arr.detect { |s| stream["trackName"] === s[:trackName]}
  if match
    match[:playCount] += 1
  else
    arr << {trackName: stream["trackName"], artistName: stream["artistName"], playCount: 1 }
  end
end

transformed = arr.sort_by {|s| -s[:playCount]}.take(10)
