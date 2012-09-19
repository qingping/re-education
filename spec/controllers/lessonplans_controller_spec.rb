require 'spec_helper'

describe LessonplansController do
  describe :index do
    it "lists 4 latest lesson plans" do
      10.times do |i|
        plan = Lessonplan.create!(:title => "test_plan_#{i}")
        plan.update_attribute(:created_at, (60-i).minutes.ago)
      end
      
      get :index
      listed_plans = assigns(:lessonplans)
      listed_plans.should have(4).plans
      listed_plans.first.title.should == "test_plan_9"
    end
  end
  
  describe :create do
    it "creates one lesson plan and redirect to show page" do
      lambda do
        post :create, :lessonplan => {:title => 'test_plan', :content => 'This is a test plan.'}
      end.should change(Lessonplan, :count).by(1)
      
      response.should redirect_to(lessonplan_path(Lessonplan.last))
    end
    it "creates tasks and associates them to one lesson plan" do
      lambda do
        post :create, :lessonplan => {:title => 'test_plan', :content => 'This is a test plan.'},
                      :tasks => [{:title => 'test_task', :content => 'This is a test task.'}]
      end.should change(Task, :count).by(1)
      Lessonplan.last.tasks.should have(1).task
      Lessonplan.last.tasks.first.title.should == 'test_task'
    end
  end
end
