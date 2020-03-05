require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    students = []
    
    doc.css('div.student-card').each do |item| 
      doc.css('h4.student-name').each do |name| 
        students <<{:name => name.text}
      end 
    end
    
    students.each do |student|
      doc.css('p.student-location').each do |loc|
        student[:location] = loc.text
      end
    end
    
    students.each do |student|
      doc.css('div.student-card a').each do |url|
        student[:profile_url] = url.attribute('href').value
      end
    end
    
    students
    
  end

  def self.scrape_profile_page(profile_url)
    
  end

end


