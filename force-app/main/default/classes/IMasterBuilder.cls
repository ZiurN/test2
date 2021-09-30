public interface IMasterBuilder  {
		List<Object> callWebService();
		void processResponse(List<Object> datas);
		void updateDate();
}