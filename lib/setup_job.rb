class SetupJob < Struct.new(:task)
  def perform
    Medvane::Setup.send(task)
  end
end