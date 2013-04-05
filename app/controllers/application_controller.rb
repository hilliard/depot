#---
# Excerpted from "Agile Web Development with Rails",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#---

class ApplicationController < ActionController::Base
     before_filter :set_i18n_locale_from_params
  	 # before_filter :authorize
     protect_from_forgery

  private

    def current_cart 
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end

  protected
  
  def authorize
        unless User.find_by_id(session[:user_id]) or User.count == 0
            session[:original_uri] = request.request_uri
            flash[:notice] = "Please log in." 
            redirect_to(:controller=>"login", :action=>"login")
        end
        if (User.count == 0 and request.path_parameters['action'] != "add_user")
                flash[:notice] = "Please create an account." 
                redirect_to(:controller=>"login", :action=>"add_user")
        end
  end
  def set_i18n_locale_from_params
    if params[:locale]
       if I18n.available_locales.include?(params[:locale].to_sym)
         I18n.locale = params[:locale]
       else
         flash.now[:notice]=
           "#{params[:locale]} translation not available"
            logger.error flash.now[:notice]
       end
      end
    end
   def default_url_options
     { :locale => I18n.locale }
   end


end