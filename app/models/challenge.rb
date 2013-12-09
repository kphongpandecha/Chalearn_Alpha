class Challenge < ActiveRecord::Base
  attr_accessible :description, :end_time, :start_time, :title, :yamlformat, :webpages_attributes, :phrases_attributes, :user_id, :timestamps
  has_many :webpages, :dependent => :destroy
  has_many :phrases, :dependent => :destroy
  belongs_to :user
  accepts_nested_attributes_for :webpages, :allow_destroy => true
  accepts_nested_attributes_for :phrases, :allow_destroy => true

  def getTmpZipName
    return 'tmp'+ self.id.to_s + '.zip'
  end

  def getTmpYmlName
    return 'tmp' + self.id.to_s + '.yml'
  end

  def getyaml_hash
    #Creating yaml hash
    yaml_hash = Hash.new()
    self.attributes.each do |attr_name, attr_value|
    	yaml_hash[attr_name] = attr_value
    end

    #Prepare webpage for
    yaml_html = Hash.new()
    self.webpages.each do |webpage|
    	yaml_html[webpage.title] = webpage.webpage_yaml
    end
    yaml_hash["html"] = yaml_html

    #Prepare phase hash for yaml file
    yaml_phase = Hash.new()
    self.phrases.each_with_index do |phrase, index|
    	yaml_phase[index+1] = phrase.phase_yaml
    end
    yaml_hash["phase"] = yaml_phase

    return yaml_hash
  end

  def appendWebpage(file_path)
   if not webpage.title.empty?
        html_name = webpage.title + '.html'
        File.open(file_path + html_name, "w+") do |file|
                file.write(webpage.web_content)
        end

        #Add each html to zip
        zipfile.add(html_name,file_path + html_name)
    end
  end

  def appendFiletoZip(file_path)
    #Creating html and zip files
    Zip::File.open(file_path + self.getTmpZipName,Zip::File::CREATE) do |zipfile|
      self.webpages.each do |webpage|
        self.appendWebpage(file_path)
      end
      #Add yml to the zip
      zipfile.add(self.getTmpYmlName,file_path + self.getTmpYmlName)
    end
  end

  def createZip(file_path)
    yaml_hash = self.getyaml_hash

    #Create yaml file
    File.open(file_path + self.getTmpYmlName, "w+") do |file|
      file.write(yaml_hash.to_yaml)
    end

    #Append all yaml and html files to zip
    self.appendFiletoZip(file_path)

    return file_path + self.getTmpZipName
  end

  def tempCleanUp(file_path)
    #Path parameters
    zip_path = file_path + 'tmp'+ self.id.to_s + '.zip'
    yaml_path = file_path + 'tmp' + self.id.to_s + '.yml'

    #Delete html files
    self.webpages.each do |webpage|
      if not webpage.title.empty?
        html_name = webpage.title + '.html'
        File.delete(file_path + html_name)
      end
    end

    File.delete(zip_path) #Delete zip file
    File.delete(yaml_path) #Delete yaml file
  end

end
