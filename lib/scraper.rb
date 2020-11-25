require 'open-uri'
require 'pry'

class Scraper
  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    students = []

    page.css(".student-card").each do |student|
      new_student = {}
      new_student[:name] = student.css("h4").text
      new_student[:location] = student.css("p").text
      new_student[:profile_url] = student.css("a").attribute("href").value
      students << new_student
    end

    students
  end

  def self.scrape_profile_page(profile_url)
    page = Nokogiri::HTML(open(profile_url))
    student = {}
    social_links = page.css(".social-icon-container").css("a").collect {|link| link.attribute("href").value}
    
    social_links.each do |link|
      if link.include?("twitter")
        student[:twitter] = link
      elsif link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      else
        student[:blog] = link
      end
    end
    
    student[:profile_quote] = page.css(".vitals-text-container").css(".profile-quote").text
    student[:bio] = page.css(".description-holder").css("p").text

    student
  end
  
end

# Scrape name, location, profile_url
# name = page.css(".student-card").first.css("h4").text
# location = page.css(".student-card").first.css("p").text
# profile_url = page.css(".student-card").first.css("a").attribute("href").value

# twitter = page.css(".social-icon-container").css("a")[0].attribute("href").value
# linkedin = page.css(".social-icon-container").css("a")[1].attribute("href").value
# github = page.css(".social-icon-container").css("a")[2].attribute("href").value
# blog = page.css(".social-icon-container").css("a")[3].attribute("href").value
# profile_quote = page.css(".vitals-text-container").css(".profile-quote").text
# bio = page.css(".description-holder").css("p").text

# page = Nokogiri::HTML(open('https://learn-co-curriculum.github.io/student-scraper-test-page/students/eric-chu.html'))
# social_links = page.css(".social-icon-container").css("a")
# links = social_links.collect {|link| link.attribute("href").value}
# print links
# puts social_links[1].attribute("href")
# puts social_links[1].attribute("href").value
# puts links[1].include?("linkedin")