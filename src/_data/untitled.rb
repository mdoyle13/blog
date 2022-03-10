def with_something(referrer_match, &block)
  
  fake_var = "multi_links"
  if fake_var == referrer_match
    yield fake_var
  else
    yield nil
  end
end


def do_thing
  @foo = with_something("multi_links") do |matching_referrer|
    if matching_referrer 
      5+5
    else
      nil
    end
  end

  puts @foo
end

do_thing