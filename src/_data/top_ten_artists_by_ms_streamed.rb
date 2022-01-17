require 'json'

data = File.read('src/_data/spotify_history.json')
streams = JSON.parse(data)

transformed = streams.inject({}) do |memo, stream|
  artist_name = stream["artistName"]
  if memo[artist_name]
    memo[stream["artistName"]] += stream["msPlayed"]
  else
    memo[stream["artistName"]] = stream["msPlayed"]
  end
  
  memo
end.sort_by {|k,v| [-v, k]}.to_h.take(10)
