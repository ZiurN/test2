public class Pagination {
	@AuraEnabled public String prev {get;set;} 
	@AuraEnabled public String next {get;set;} 
	@AuraEnabled public Integer current {get;set;} 
	@AuraEnabled public Integer first {get;set;} 
	@AuraEnabled public Integer last {get;set;} 
	@AuraEnabled public Integer total {get;set;} 

	public Pagination() {
		this.prev = null;
		this.next = null;
		this.current = null;
		this.first = null;
		this.last = null;
		this.total = null;
	}

	public Pagination(String prev, String next, Integer current, Integer first, Integer last, Integer total) {
		this.prev = prev;
		this.next = next;
		this.current = current;
		this.first = first;
		this.last = last;
		this.total = total;
	}
}