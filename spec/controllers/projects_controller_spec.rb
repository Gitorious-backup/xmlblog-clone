require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectsController do
  before(:each) do
    @projects = [mock_model(Project), mock_model(Project)]
  end
  
  def url_path(path, host="http://test.host")
    "#{host}#{path}"
  end
  
  it "GET projects/ should be succesful" do
    Project.should_receive(:find).and_return(@projects)
    get :index
    response.should be_success
    assigns(:projects).should == @projects
    response.should render_template("index")
  end
  
  it "GET projects/new should be succesful" do
    login_as :johan
    get :new
    response.should be_success
    response.should render_template("new")
  end
  
  it "GET projects/new should redirect to new_account_key_path if no keys on user" do
    users(:johan).ssh_keys.destroy_all
    login_as :johan
    get :new
    response.should redirect_to(new_account_key_path)
  end
  
  it "GET projects/new should require login" do
    get :new
    response.should be_redirect
    response.should redirect_to(new_sessions_path)
  end
  
  it "POST projects/create with valid data should create project" do
    login_as :johan
    post :create, :project => {:title => "project x", :slug => "projectx"}
    response.should be_redirect
    response.should redirect_to(projects_path)
    
    Project.find_by_title("project x").user.should == users(:johan)
  end
  
  it "GET projects/create should redirect to new_account_key_path if no keys on user" do
    users(:johan).ssh_keys.destroy_all
    login_as :johan
    post :create
    response.should redirect_to(new_account_key_path)
  end
  
  it "projects/create should require login" do
    post :create
    response.should redirect_to(new_sessions_path)
  end
  
  it "projects/update should require login" do
    post :update
    response.should redirect_to(new_sessions_path)
  end
  
  it "PUT projects/update with valid data should update record" do
    login_as :johan
    project = projects(:johans)
    put :update, :id => project.slug, :project => {:title => "new name", :slug => "foo"}
    assigns(:project).should == project
    response.should be_redirect
    response.should redirect_to(project_path(project.reload))
    project.reload.title.should == "new name"
  end
  
  it "projects/destroy should require login" do
    put :destroy
    response.should be_redirect
    response.should redirect_to(url_path(new_sessions_path))
  end
  
  it "PUT projects/destroy should destroy the project" do
    login_as :johan
    delete :destroy, :id => projects(:johans).slug
    response.should redirect_to(projects_path)
    Project.find_by_id(1).should == nil
  end
  
  it "GET projects/show should be success" do
    get :show, :id => projects(:johans).slug
    assigns[:project].should == projects(:johans)
    response.should be_success
  end
  
  it "GET projects/show should fetch the repositories for a project" do
    get :show, :id => projects(:johans).slug
    assigns[:repositories].should == projects(:johans).repositories
    response.should be_success
  end
  
  it "GET projects/xx/edit should be a-ok" do
    get :edit, :id => projects(:johans).slug
    response.should be_success
  end

end
