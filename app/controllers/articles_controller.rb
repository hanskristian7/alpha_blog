class ArticlesController < ApplicationController
    before_action :set_article, only: [:show, :edit, :update, :destroy]
    before_action :require_user, except: [:show, :index]
    before_action :require_same_user, only: [:edit, :update, :destroy]
    
    def show
        # byebug
    end

    def index
        @articles = Article.paginate(page: params[:page], per_page: 5)
    end

    def new
        @article = Article.new
    end
    
    def edit
    end

    def create
        # render plain: params[:article]
        @article = Article.new(article_params)
        @article.user = current_user
        # render plain: @article.inspect
        if @article.save
            flash[:notice] = "Article was succesfully created!"
            redirect_to @article
        else
            render 'new'
        end
    end


    def update
        updated = @article.update(article_params)
        if updated
            flash[:notice] = "Article was succesfully updated"
            redirect_to @article
        else
            render 'edit'
        end
    end

    def destroy
        @article.destroy

        redirect_to articles_path
    end

##############################################################
    private    
    def set_article
        @article = Article.find(params[:id])
    end

    def article_params
        params.require(:article).permit(:title, :description)
    end

    def require_same_user
        if current_user != @article.user && !current_user.admin?
            flash[:alert] = "You can only make changes to your articles"
            redirect_to article_path
        end
    end
##############################################################

end