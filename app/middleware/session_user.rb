
class SessionUser

  def initialize(app)
    @app = app
  end

  def call(env)
    binding.pry
  end

end
