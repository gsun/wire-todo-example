import utest.Runner;
import utest.ui.Report;
import utest.Assert;

class Test {
	public static function main() {
		utest.UTest.run([new SimpleTest()]);
	}
}

class SimpleTest extends utest.Test {
	public function testVoid() {
		var todo = new TodoModel();
		todo.create("task1text", "task1note", false);

		var count:Int = cast Wire.data(DataKeys.COUNT).value;
		Assert.equals(count, 1);
		var todoList:Array<String> = cast Wire.data(DataKeys.LIST).value;
		var todoVO:TodoVO = cast Wire.data(todoList[0]).value;
		Assert.equals(todoVO.text, "task1text");
		Assert.equals(todoVO.note, "task1note");
		Assert.equals(todoVO.completed, false);
	}
}
