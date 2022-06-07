/**-----------------------------------------------------------------------------------------------------------------------
@author			Jeferson Ruiz.
@description	Clase de pruebas para generar mocks de otras clases.
@date			07/06/2022
------------------------------------------------------------------------------------------------------------------------*/
@isTest
@SuppressWarnings('PMD.ExcessiveParameterList')
public class MockProvider implements System.StubProvider {
	public Integer timesEventWasFired = 0;
	public eventFiredRegistry lastEventFiredRegistry {get; set;}
	public Object handleMethodCall (Object stubbedObject,
									String stubbedMethodName,
									Type returnType,
									List<Type> listOfParamTypes,
									List<String> listOfParamNames,
									List<Object> listOfArgs) {
		if (stubbedMethodName == 'handleFiredEvent') {
			Map<String, Object> paramsMap = new Map<String, Object>();
			for (integer i = 0; i < listOfParamNames.size(); i++) {
				paramsMap.put(listOfParamNames.get(i), listOfArgs.get(i));
			}
			this.lastEventFiredRegistry = new eventFiredRegistry(paramsMap);
			timesEventWasFired++;
		}
		return null;
	}
	public class eventFiredRegistry {
		public SS_Response_Event__e event {get; set;}
		public eventFiredRegistry (Map<String, Object> paramsMap) {
			this.event = (SS_Response_Event__e) paramsMap.get('event');
			SSResponseEventTriggerHandler realHandler =  new SSResponseEventTriggerHandler();
			realHandler.handleFiredEvent(event);
		}
	}
}