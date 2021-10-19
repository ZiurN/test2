@IsTest
public class PaginationTest  {
	static String prev;
	static String next;
	static Integer current;
	static Integer first;
	static Integer last;
	static Integer total;
	
	static {
		prev = 'testPrev';
		next = 'testNext';
		current = 2;
		first = 1;
		last = 3;
		total = 30;
	}
	
	@IsTest
	public static void constructorEmpty() {
		Test.startTest();
		Pagination paginado = new Pagination();
		Test.stopTest(); 
	}	

	@IsTest
	public static void constructorParams() {
		Test.startTest();
		Pagination paginado = new Pagination(prev, next, current, first, last, total);
		Test.stopTest();
		
		System.assertEquals('testPrev', paginado.prev);
		System.assertEquals('testNext', paginado.next);
		System.assertEquals(2, paginado.current);
		System.assertEquals(1, paginado.first);
		System.assertEquals(3, paginado.last);
		System.assertEquals(30, paginado.total);
	}	
}