require 'open-uri'
require 'nokogiri'
require 'pry'


class Scraper

  def self.scrape_index_page(index_url)
    
    doc = Nokogiri::HTML(open(index_url))
    students = []
    
    doc.css("div.roster-cards-container").each do |item|
      item.css('.student-card a').each do |student|
        student_link = student.attr('href')
        student_name = student.css('.student-name').text
        student_loc = student.css('p.student-location').text
        students<<{name: student_name, location: student_loc, profile_url: student_link}
      end
    end 
    students
  end

  def self.scrape_profile_page(profile_url)
    
    doc = Nokogiri::HTML(open(profile_url))
    student_media = {}
    links = doc.css('div.social-icon-container a')
    
    list = []
    
    sites_array = ['twitter', 'github', 'linkedin']

    info = []
    
    links.each do |link|
      list << link.attribute('href').value
    end 
    list.each do |site|
      sites_array.each do |check|
        if site.include?(check)
          info << {check.to_sym => site}
        elsif !site.include?(sites_array[0]) && !site.include?(sites_array[1]) && !site.include?(sites_array[2])
          info << {blog: site}
        end 
      end 
    end 
    profile_quote = doc.css('div.profile-quote').text
    bio = doc.css('div.description-holder p').text
    info << {profile_quote: profile_quote} 
    info << {bio: bio}
    info_hash = {}
    info.each do |a|
      info_hash[a.keys[0]] = a.values[0]
    end 
    info_hash
  end

end


