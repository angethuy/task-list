require "test_helper"

describe TasksController do
  let (:task) {
    Task.create name: "sample task", description: "this is an example for a test",
    completed_at: Time.now + 5.days
  }
  
  # Tests for Wave 1
  describe "index" do
    it "can get the index path" do
      # Act
      get tasks_path
      
      # Assert
      must_respond_with :success
    end
    
    it "can get the root path" do
      # Act
      get root_path
      
      # Assert
      must_respond_with :success
    end
  end
  
  # Unskip these tests for Wave 2
  describe "show" do
    it "can get a valid task" do
      
      # Act
      get task_path(task.id)
      
      # Assert
      must_respond_with :success
    end
    
    it "will redirect for an invalid task" do
      
      # Act
      get task_path(-1)
      
      # Assert
      must_respond_with :redirect
    end
  end
  
  describe "new" do
    it "can get the new task page" do
      
      # Act
      get new_task_path
      
      # Assert
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "can create a new task" do
      
      
      # Arrange
      task_hash = {
        task: {
          name: "new task",
          description: "new task description",
          completed_at: nil,
        },
      }
      
      # Act-Assert
      expect {
        post tasks_path, params: task_hash
      }.must_change "Task.count", 1
      
      new_task = Task.find_by(name: task_hash[:task][:name])
      expect(new_task.description).must_equal task_hash[:task][:description]
      expect(new_task.completed_at).must_equal task_hash[:task][:completed_at]
      
      must_redirect_to task_path(new_task.id)
    end
  end
  
  # Unskip and complete these tests for Wave 3
  describe "edit" do
    it "can get the edit page for an existing task" do
      # Act
      get edit_task_path(task.id)

      #Assert 
      must_respond_with :success
    end
    
    it "will respond with redirect when attempting to edit a nonexistant task" do
      # Act
      get edit_task_path(-1)

      # Assert 
      must_redirect_to tasks_path
      
    end
  end
  
  # Uncomment and complete these tests for Wave 3
  describe "update" do
    before do 
      Task.create(name: "swim the english channel", description: "no thank you", completed_at: "in my dreams")
    end
    let (:new_task_hash) {
      {
        task: {
          name: "eat cake for breakfast",
          description: "but it has bananas so it's ok",
          completed_at: "all the days",
        },
      }
    }

    it "can update an existing task" do
      expect {
        patch task_path(Task.first.id), params: new_task_hash
      }.wont_change "Task.count"
      
      must_redirect_to task_path(Task.first.id)

      task = Task.find_by(id: Task.first.id)
      expect(task.name).must_equal new_task_hash[:task][:name]
      expect(task.description).must_equal new_task_hash[:task][:description]
      expect(task.completed_at).must_equal new_task_hash[:task][:completed_at]
    end
    
    it "will redirect to the root page if given an invalid id" do
      expect {
        patch task_path(-1), params: new_task_hash
      }.wont_change "Task.count"

      must_redirect_to tasks_path
    end
  end
  
  # Complete these tests for Wave 4
  describe "destroy" do
    before do 
      Task.create(name: "join quidditch team", description: "hufflepuff will win this year", completed_at: "next year")
    end
    
    it "will delete an existing task" do
      expect {
        delete task_path(Task.first.id)
      }.must_change "Task.count", -1

      must_redirect_to tasks_path
    end

    it "will redirect to the root page if deleting an invalid task" do
      expect {
        delete task_path(-1)
      }.wont_change "Task.count"

      must_redirect_to tasks_path
    end
    
  end
  
  # Complete for Wave 4
  describe "mark_complete" do
    before do 
      Task.create(name: "go to sleep", description: "catch up on those zzzs", completed_at: "")
      @id = Task.first.id
    end

    it "will mark task as complete" do
      patch mark_complete_task_path(@id)
      expect(Task.first.completed_at).must_be_kind_of String
    end

  end

  describe "mark_incomplete" do
    before do 
      Task.create(name: "learn to fly", description: "to infinity and beyond", completed_at: Time.now)
      @id = Task.first.id
    end

    it "will mark task as incomplete" do
      patch mark_incomplete_task_path(@id)
      expect(Task.first.completed_at).must_equal ""
    end
    
  end
end
