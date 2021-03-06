class ChallengesController < ApplicationController
	require 'zip'

	#Cancan filter
	load_and_authorize_resource
	
	def index
		valid_list = ['title', 'start_time', 'end_time', nil]
		if current_user.admin? || current_user.moderator?
			@challenges = Challenge.find(:all,:order => params[:sort]) if valid_list.include? params[:sort]
		else
			@challenges = Challenge.all(:conditions => {:user_id => current_user.id},:order => params[:sort]) if valid_list.include? params[:sort]
		end
	end

    def getstream
        #Challenge
        challenge = Challenge.find_by_id(params[:id])

        #Create zip file
        zip_path = challenge.createZip

    	#Sending zip
	    zip_file = File.read(zip_path)
	    send_data zip_file, :filename => challenge.title + '.zip', :x_sendfile => true
        
        #Data clean up
        challenge.tempCleanUp
    end


	def new
		@challenge = Challenge.new
		12.times {@challenge.webpages.build}
		3.times do
			phrase = @challenge.phrases.build
			3.times {phrase.tasks.build}	
		end
	end

	def edit
		@challenge = Challenge.find(params[:id])
	end

	def show
		@challenge = Challenge.find(params[:id])
	end

	def create
		@challenge = Challenge.new(params[:challenge])
		if @challenge.save
			flash[:notice] = "Successfully created '#{@challenge.title}' challenge"
			redirect_to @challenge
		else 
			render :action => 'new'
		end
	end

	def update
		@challenge = Challenge.find(params[:id])
		if @challenge.update_attributes(params[:challenge])
			flash[:notice] = "Successfully updated '#{@challenge.title}' challenge"
			redirect_to @challenge
		else
			render :action => 'edit'
		end
	end

	def destroy
		@challenge = Challenge.find(params[:id])
		@challenge.destroy 
		flash[:notice] = "Challenge '#{@challenge.title}' deleted."
		redirect_to challenges_path
	end
end
