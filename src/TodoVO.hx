
class TodoVO {
  public var completed:Bool;
  public var text:String;
  public var note:String;
  public var id:String;
  public var visible:Bool;

  public function new(id:String, text:String, note:String, completed:Bool) {
	this.id = id;
	this.text = text;
	this.note = note;
	this.completed = completed;
	this.visible = true;
  }
}