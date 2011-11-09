#!/usr/bin/env ruby
# grab materials from the blender open materials repository.
require 'mechanize'
require 'tempfile'
require 'open-uri'
require 'uri'

class String
  def to_tag
    #strip the string
    ret = self.strip.downcase

    #blow away apostrophes
    ret.gsub! /['`]/,""

    # @ --> at, and & --> and
    ret.gsub! /\s*@\s*/, " at "
    ret.gsub! /\s*&\s*/, " and "

    #replace all non alphanumeric, underscore or periods with dot
    ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '.'  

    #convert double dots to single
    ret.gsub! /\.+/,"."

    #strip off leading/trailing underscore
    ret.gsub! /\A[_\.]+|[_\.]+\z/,""

    ret
  end

  def to_slug
    #strip the string
    ret = self.strip.downcase

    #blow away apostrophes
    ret.gsub! /['`]/,""

    # @ --> at, and & --> and
    ret.gsub! /\s*@\s*/, " at "
    ret.gsub! /\s*&\s*/, " and "

    #replace all non alphanumeric, underscore or periods with hyphen
    ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '-'  

    #convert double hyphen to single
    ret.gsub! /-+/,"-"

    #strip off leading/trailing hyphen
    ret.gsub! /\A[-\.]+|[-\.]+\z/,""

    ret
  end
end

$index_url = 'http://matrep.parastudios.de/index.php?p=7'
agent = Mechanize.new

def get_material(agent, material_url)
  page = agent.get(material_url)

  # get title
  title = page.parser.xpath('/html/body/div[2]/div[2]/h1/text()').to_s

  # get tags
  category = page.parser.xpath('/html/body/div[2]/div[2]/div[2]/div/span/a[2]/text()').to_s
  tags = category.split('/').map { |word| word.to_tag }

  # get description
  elements = []
  ready = false;
  page.parser.at_css('html body div.bigone div.padd div div').children.each do |node|
    if !ready
      if node.text == 'Description/Information:'
        ready = true
      end
    else
      elements << node.to_s
    end
  end
  description = elements.join("\n")

  # get image
  image_url = page.parser.at_css('html body div.bigone div.padd div img#bild')['src']
  image_url = URI.join($index_url, image_url)

  # get blend
  blend_url = page.parser.at_css('html body div.bigone div.padd div div a.download')['href']
  blend_url = URI.join($index_url, blend_url)
  blend = Tempfile.new('blend')
  blend_path = blend.path
  blend.close!
  agent.get(blend_url).save_as blend_path

  # add new Material object
  material = Material.create(:title => title, :description => description)
  material.tag_list = tags
  material.image = open(image_url)
  material.blend = open(blend_path)
  material.save
end

def get_category(agent, category_url)
  category = agent.get(category_url)
  category.parser.xpath('/html/body/div[2]/div[2]/div/ul/li/div/a').each do |link|
    get_material(agent, URI.join($index_url, link['href']))
  end
end

task :getmaterials => :environment do
  index = agent.get($index_url)
  index.parser.xpath('/html/body/div[2]/div[2]/div/ul/li/div/a').each do |link|
    get_category(agent, link['href'])
  end
end
