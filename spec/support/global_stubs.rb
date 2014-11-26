module GlobalStubs
  def add_global_stubs
    add_user_api_stub
  end

  def add_user_api_stub
    allow(MapUserToApi).to receive(:call).and_return(true)
  end

  def remove_user_api_stub
    allow(MapUserToApi).to receive(:call).and_call_original
  end
end
