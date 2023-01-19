class AccountsController < ApplicationController
    before_action :authenticate_account!
    before_action :set_account, only: [:profile]

    def index
        
        following_ids = Follower.where(follower_id: current_account.id).map(&:following_id)
        following_ids << current_account.id

        @posts = Post.active.where(account_id: following_ids)
       
        @comment = Comment.new

        @follower_suggestions = Account.where(user_type:2).where.not(id: following_ids)

        followers = Follower.where(following_id: current_account.id)
        follower_ids = followers.map(&:follower_id)
        @followers = Account.where(id: follower_ids)

        @following_accounts = Account.where(id: following_ids)
        @following_accounts = @following_accounts.where.not(id: current_account.id)

    end

    def followers
        # user dashboard feed
        following_ids = Follower.where(follower_id: current_account.id).map(&:following_id)
        following_ids << current_account.id

        @follower_suggestions = Account.where(user_type:2).where.not(id: following_ids)

        followers = Follower.where(following_id: current_account.id)
        follower_ids = followers.map(&:follower_id)
        @followers = Account.where(id: follower_ids)

        @following_accounts = Account.where(id: following_ids)
        @following_accounts = @following_accounts.where.not(id: current_account.id)
    end

    def profile
        #user profile pics of post
        #@posts = @account.posts.active
      
     
        if current_account == @account
            @posts = @account.posts.active
        else
            following_ids = Follower.where(follower_id: current_account.id).map(&:following_id)
            if following_ids.include?(@account.id)
                @posts = @account.posts.active.where(account_id: @account.id)
            else
               
                @posts = []
            end
        end
    end

    def follow_account

        follower_id = params[:follow_id]
        if Follower.create!(follower_id: current_account.id, following_id: follower_id)
            flash[:success] = "Now following user"
        else
            flash[:danger] = "Unable to add follower" 
        end

        redirect_to dashboard_path
    end

    def admin_dashboard
        @total_accounts = Account.count
        @online_accounts = Account.where("current_sign_in_at is not null").count
        @offline_accounts = @total_accounts - @online_accounts

    end
 
    private

    def set_account
        @account = Account.find_by_username(params[:username])
    end
end
