require 'spec_helper'

describe UsersController do

end
require 'spec_helper'

describe UsersController do
  it "creates a user" do
    expect { 
      post :create_client, user: attributes_for(:user)
    }.to change(User,:count).by(1)
  end
end