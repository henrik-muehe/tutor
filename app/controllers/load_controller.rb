require 'csv'    

class LoadController < ApplicationController
  before_filter :authenticate_user!
  before_filter do 
    unless current_user && current_user.admin
      flash[:notice]="No access." 
      redirect_to "/tutorial"
    end
  end

  def index
  end

  def clean(v)
  	v.gsub(/^"/,'').gsub(/"$/,'')
  end

  def tumonline
    ActiveRecord::Base.transaction do
      c = Course.find(params["load"]["course_id"])

      CSV.foreach(params["load"]["file"].tempfile.path, { :encoding => 'bom|utf-8', :headers => true }) do |row|
        s = Student.create(
          :firstname => row["Vorname"], 
          :lastname => row["Familien- oder Nachname"], 
          :matrnr => row["Matrikelnummer"], 
          :email => row["E-Mail"]
        )

        g = c.groups.where(:name => row["Gruppe"])
        if g.length == 0 then
          g = c.groups.create(:name => row["Gruppe"])
          g.save
        end
        s.groups << g
        s.save
      end
    end
  end

  def tutoren
    ActiveRecord::Base.transaction do
      c = Course.find(params["load"]["course_id"])

      CSV.foreach(params["load"]["file"].tempfile.path, { :encoding => 'bom|utf-8', :headers => true, :col_sep => ';' }) do |row|
        next if row["name"].nil?

        lastname,firstname = row["name"].split(", ")
        password = rand(36**8).to_s(36)
        u = User.create_with({
          :firstname => firstname,
          :lastname => lastname,
          :password => password,
          :password_confirmation => password
        }).find_or_create_by({:email => row["email"]})

        g = c.groups.where(:name => row["group"])
        if g.length == 0 then
          g = c.groups.create(:name => row["group"])
          g.save
        else
          g=g.first
        end
        g.start = row["when"]
        g.room = row["room"]
        g.user = u
        g.save
      end
    end
  end
end
