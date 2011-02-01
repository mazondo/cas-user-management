class PasswordResetsController < ApplicationController
	#we need to load the user for the edit/update functions
	before_filter :load_user_using_perishable_token, :only => [:edit, :update]
	#no currently logged in users!
	before_filter :require_no_user
	skip_before_filter :require_user
	
	def new  
		render 
	end
	
	def edit
		render
	end
	  
	def create  
		@user = User.find_by_email(params[:email])  
		if @user  
			@user.deliver_password_reset_instructions!  
			flash[:notice] = "Instructions to reset your password have been emailed to you. " +  
			"Please check your email."  
			redirect_to new_password_reset_path  
		else  
			flash[:warning] = "No user was found with that email address"  
			render :action => :new  
		end  
	end
	
	def update
		@user.password = params[:user][:password]  
		@user.password_confirmation = params[:user][:password_confirmation]  
		if @user.save  
			flash[:notice] = "Password successfully updated"  
			redirect_to account_url  
		else  
			render :action => :edit  
		end  
	end  
  
private  
	def load_user_using_perishable_token  
		@user = User.find_using_perishable_token(params[:id])  
		unless @user  
			flash[:warning] = "Sorry, but we were unable to locate your account with the ID you provided.  Please contact an administrator or start the process over."  
			redirect_to new_password_reset_path
		end
	end
	
	def skip_cas
		true
	end
end
