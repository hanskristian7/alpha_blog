class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :require_user, except: [:show, :index]
    before_action :require_same_user, only: [:edit, :update, :destroy]
    
    def index
        @users = User.paginate(page: params[:page], per_page: 5)
    end

    def show
        @articles = @user.articles.paginate(page: params[:page], per_page: 5)
    end

    def new
        @user = User.new
    end

    def edit
        
    end

    def create
        # byebug
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            flash[:notice] = "You have successfully signed up, #{@user.username}!"
            redirect_to @user
        else
            render 'new'
        end
    end

    def update
        updated = @user.update(user_params)
        if updated
            flash[:notice] = "Your Account has been updated!"
            redirect_to @user
        else
            render 'edit'
        end
    end

    def destroy
        @user.destroy
        session[:user_id] = nil if @user == current_user
        flash[:notice]="Account and all associated articles successfully DELETED!"
        redirect_to root_path
    end
    
    
private
    def set_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:username, :email, :password)
    end
    def require_same_user
        if current_user != @user && !current_user.admin?
            flash[:alert] = "You can only make changes to your articles"
            redirect_to user_path
        end
    end
end