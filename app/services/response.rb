class Response
  attr_reader :data, :message
  def initialize(data, message)
    @data = data
    @message = message
  end

  def success?
    raise NotImplementedError
  end
end

class Success < Response
  def success?
    true
  end
end

class Failure < Response
  def success?
    false
  end
end