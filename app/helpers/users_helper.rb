module UsersHelper

	#from flash type to bootstrap class
	def flash_class(level)
		#byebug
    	case level
	        when "notice" then "alert alert-info"
	        when "success" then "alert alert-success"
	        when "error" then "alert alert-danger"
	        when "alert" then "alert alert-danger"
	        else "xxxxxx"
    	end
	end

end
