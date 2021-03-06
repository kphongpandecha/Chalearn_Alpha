#Append the following entries into the challenge table
Given /the following challenges exist/ do |challenges_table|
	challenges_table.hashes.each do |challenge|
		Challenge.create!(challenge)
	end
end

Then /the following challenges should be in the database/ do |challenges_table|
  challenges_table.hashes.each do |challenge|
    object = Challenge.find_by_title(challenge[:title])
    assert object != nil
  end
end

Then /the following challenges should not be in the database/ do |challenges_table|
  challenges_table.hashes.each do |challenge|
    object = Challenge.find_by_title(challenge[:title])
    assert object == nil
  end
end

Then /^I should receive a zip file "(.*)"$/ do |file|
  result = page.response_headers['Content-Type'].should == "application/zip"
  if result
    result = page.response_headers['Content-Disposition'].should =~ /#{file}/
  end
  result
end

#Assert start_time attribute of a challenge
Then /the start time of "(.*)" should be "(.*)"/ do |title,start_time|
	challenge = Challenge.find_by_title(title)
	assert challenge.start_time == start_time
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.

  # Assert that the string of the page has e1 then anything(including newlines becaz /m) then e2 
  assert page.body =~ /#{e1}.*#{e2}/m, "{e1} is not before #{e2}"
end
