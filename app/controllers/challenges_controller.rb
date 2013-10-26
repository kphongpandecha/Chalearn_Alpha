class ChallengesController < ApplicationController
	
	def index
		@challenges = Challenge.all
	end 

	def new
		@challenge = Challenge.new
		4.times {@challenge.webpages.build}
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