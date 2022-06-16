# Pundit is probably the most widely used authorization gem in the rails community.
# It lets you setup rules for who should be allowed to do what in your application.
# https://github.com/varvet/pundit

# This is achieved by defining a so called "Policy" to protect a certain model, e.g:
class BlogPolicy
  attr_reader :user, :blog

  def initialize(user, blog)
    @user = user
    @blog = blog
  end

  def show?
    published? ? true : admin?
  end

  def create?
    admin?
  end

  def new?
    admin?
  end

  def update?
    admin?
  end

  def edit?
    admin?
  end

  def destroy?
    admin?
  end

  private

  def admin?
    user && user.admin?
  end

  def published?
    blog.published?
  end
end

# Blog controller using pundit lifted from my meal planner app:
class BlogsController < ApplicationController
  before_action :set_blog, only: %i[show edit update destroy]
  before_action :set_recent_blogs, only: %i[show]
  skip_before_action :authenticate_user!, only: %i[index show]

  def show; end

  def new
    authorize Blog
    @blog = Blog.new
  end

  def edit; end

  def create
    authorize Blog
    @blog = Blog.new(blog_params)

    if @blog.save
      redirect_to @blog, notice: 'Blog was successfully created.'
    else
      render :new
    end
  end

  def update
    if @blog.update(blog_params)
      redirect_to @blog, notice: 'Blog was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @blog.destroy
    redirect_to blogs_url, notice: 'Blog was successfully destroyed.'
  end

  private

  def set_blog
    @blog = authorize Blog.find_by_slug(params[:id])
  end

  def set_recent_blogs
    @recent_blogs = Blog.where(published: true).last(5).reverse
  end

  def blog_params
    params.require(:blog).permit(:title, :body, :category, :published)
  end
end
