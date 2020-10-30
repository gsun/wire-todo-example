using Lambda;

enum FilterValues {
  ALL;
  ACTIVE;
  COMPLETED;
}

class TodoModel {
  static public var LOCAL_STORAGE_KEY:String = 'todo-mvc-haxe-wire';

  public function new() {
    var idsList:Array<String> = [];
    var notCompletedCount = 0;
    trace('> TodoModel list: ${idsList.length}');
    trace('> TodoModel count: ${notCompletedCount}');
    Wire.data(DataKeys.LIST, idsList);
    Wire.data(DataKeys.COUNT, notCompletedCount);
  }

  public function create(text:String, note:String, completed:Bool) : TodoVO {
    var time = Date.now();
    var id = time.toString();
    var todoVO = new TodoVO(id, text, note, completed);
    var todoList:Array<String> = cast Wire.data(DataKeys.LIST).value;
    var count:Int = cast Wire.data(DataKeys.COUNT).value;

    todoList.push(todoVO.id);
    Wire.data(todoVO.id, todoVO);
    Wire.data(DataKeys.LIST, todoList);
    Wire.data(DataKeys.COUNT, count + (completed ? 0 : 1));

    trace('> TodoModel -> created: ' + todoVO.id + ' - ' + todoVO.text);
    return todoVO;
  }

  public function remove(id:String) : TodoVO {
    var todoList:Array<String> = cast Wire.data(DataKeys.LIST).value;
    var count:Int = cast Wire.data(DataKeys.COUNT).value;
	var todoWireData = Wire.data(id);
    var todoVO:TodoVO = cast todoWireData.value;

    todoList.remove(id);
    todoWireData.remove();

    if (todoVO.completed == false) {
      Wire.data(DataKeys.COUNT, count - 1);
    }

    Wire.data(DataKeys.LIST, todoList);

    trace('> TodoModel -> removed: ' + id);
    return todoVO;
  }

  public function update(id:String, text:String, note:String) : TodoVO {
    var todoWireData = Wire.data(id);
    var todoVO:TodoVO = cast todoWireData.value;
    todoVO.text = text;
    todoVO.note = note;
    // Wire.data<TodoVO>(id, todoVO);
    todoWireData.refresh();

    trace('> TodoModel -> updated: ' + todoVO.id + ' - ' + todoVO.text);
    return todoVO;
  }

  public function toggle(id:String) : TodoVO {
    var todoVO:TodoVO = cast Wire.data(id).value;
    var count:Int = cast Wire.data(DataKeys.COUNT).value;

    todoVO.completed = !todoVO.completed;

    Wire.data(id, todoVO);
    Wire.data(DataKeys.COUNT, count + (todoVO.completed ? -1 : 1));


    trace('> TodoModel -> toggled: ' + todoVO.id + ' - ' + todoVO.text);
    return null;
  }

  public function filter(filter:FilterValues) : Void {
    var todoList:Array<String> = cast Wire.data(DataKeys.LIST).value;
    for (id in todoList) {
      var todoVO:TodoVO = cast Wire.data(id).value;
      var todoVisible =  switch (filter) {
        case FilterValues.ALL: true;
        case FilterValues.ACTIVE: todoVO.completed?false:true;
        case FilterValues.COMPLETED: todoVO.completed;
      }
      if (todoVO.visible != todoVisible) {
        todoVO.visible = todoVisible;
        Wire.data(id, todoVO);
      }
    }
    Wire.data(DataKeys.FILTER, filter);
    trace('> TodoModel -> filtered: ' + filter);
  }

  public function setCompletionToAll(value:Bool) : Void {
    var todoList:Array<String> = cast Wire.data(DataKeys.LIST).value;
    var count:Int = cast Wire.data(DataKeys.COUNT).value;
    trace('> TodoModel -> setCompletionToAll: $value - ' + count);
    for (id in todoList) {
      var todoVO:TodoVO = cast Wire.data(id).value;
      if (todoVO.completed != value) {
        count += (value ? -1 : 1);
        todoVO.completed = value;
        Wire.data(id, todoVO);
      }
    }
    Wire.data(DataKeys.COUNT, count);
  }

  public function clearCompleted() : Void {
    var todoList:Array<String> = cast Wire.data(DataKeys.LIST).value;
	var newTodoList:Array<String> = [];
    for (id in todoList) {
      var todoWireData = Wire.data(id);
      var todoVO:TodoVO = cast todoWireData.value;
      if (todoVO.completed) {
        todoWireData.remove();
      } else {
		newTodoList.push(id);
	  }
    }

    Wire.data(DataKeys.LIST, newTodoList);

    trace('> TodoModel -> clearCompleted: length = ' + newTodoList.length);
  }
}