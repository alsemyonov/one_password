module OnePassword
  class Error < StandardError
  end

  class UndefinedProfile < Error
    def initialize(profile_name)
      super "Undefined profile #{profile_name.inspect}"
    end
  end
end
