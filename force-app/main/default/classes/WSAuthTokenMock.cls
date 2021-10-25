@isTest
public class WSAuthTokenMock {
	public static String getTokenSuccess(){
		return
			'{' +
				'"token_type": "Bearer",' +
				'"expires_in": 2592000,' +
				'"access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjkzODBiMzhiM2FlMzBlYmQ5ZTY3MjhlY2JjNWFjOWUyMDBhYjFlZjM4OTQwMzhlNDg0ODViMTNmODM4N2UyMDU5NzkwOGEyYzE3ZTBhZTBkIn0.eyJhdWQiOiIyIiwianRpIjoiOTM4MGIzOGIzYWUzMGViZDllNjcyOGVjYmM1YWM5ZTIwMGFiMWVmMzg5NDAzOGU0ODQ4NWIxM2Y4Mzg3ZTIwNTk3OTA4YTJjMTdlMGFlMGQiLCJpYXQiOjE1OTMwOTcxMTEsIm5iZiI6MTU5MzA5NzExMSwiZXhwIjoxNTk1Njg5MTExLCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.eTs01Oe7KQ_-fSjK7nKZyYcAZvplkFQ9qqQ_hHKvk1cmT7zkCRezkmUsC7P50B5FvMdbuSxCRCU9hvU1Tss52-YGbyNyAA2sBABcA-mswoGipf1irH_JAPwifNraCPGNZbmIkmAU4ySoIm4lu_zPX5ycTnPoZnUWpkWx4FJVyPzXWcpsHjJVownvA3rTr1xOtfbbef7_lRABItGZ0MIo6smzknX2MDxOu2Zzt4cAPd86aOGyaTnYEXPeVJmr3_dlZR4xwCca5Jac2UjMomZJya0jeDcscVtxXmRbbXzeSPQW85ZGEp7iVf6VbBAD-N0Isd2qf_FSuDj2EWowiKyy2sVZ15OZuMhnJGxTpFC8RK3cfucgNyWeJ-LR3ivnjzrDe-UdP2vShfu95zcX4WvfX3EGPkBVItWbJEBcaQZUAdszkT9elwW0GswXd1zlxejSydATu47r_garAmq6815MdAV8ImoiuyHic7zlABvfRYPKGeJbh0OcENBPVQ4MBJiM5CgHB_NcXIGkgTqQNarDcpOhIglSF15OX2TFJQIMT5R9q_hO6kjAmRzMhLhL4fSEjf3Tkv3eNGa9SowpOZrzf5-g90ERHtGyXApcuRerEOgZzEwaMqk-CpM0kGP6n6N9mfqNTX_WQgpLTnnQfOE7HNHuf5NWpY6D5CzVG6lNZN4",' +
				'"refresh_token": "def50200bfb6e07f553cdf4125c5fe9a90fe13fc88eede9b37159d5058ff55a765af4c78346758d7e570356ef907d5d456fae7f7e510716ad3fa0c4e94598465f9af523b3ecefd5001cae72387fe3ba195ff3b7760b44b171796260a5295eb2566fd555d4de38d59b14e12bbf9d99b4662fd4c1e271b30ec9697fb132fc8d1a0c1dc9de41712c1142dc91e61bccfb15f0ec785a697332d0c7332072735e8e8d406b2112291afd650516f41c625d20094017fb20d7cad2af2ed4eaccd60ada74c1d225ad0c6559700070471d0f99be143e8df93663226eaecbaab0a610fa4e1c0da41b71119a6a557499ec983b72b91cb0aefcab8e7a23d0795e0cd61bbc163c388981447dca262c90127ba7196688227a15a28269dc637b8d8f902f340b21d24afb2d7a4352df7003dd890c72e4426eca95ae621ff9b783b1734559773df43dbd93135ac91b987ece4a024d9bc41912f4661fd1fe1956a38c07903489e4e73effa"' +
			'}';
	}
	public static String getInvalidCredentialsError(){
		return
			'{' +
				'"error": "invalid_credentials",' +
				'"error_description": "The user credentials were incorrect.",' +
				'"message": "The user credentials were incorrect."' +
			'}';
	}
	public static String getAccessToken() {
		return 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjkzODBiMzhiM2FlMzBlYmQ5ZTY3MjhlY2JjNWFjOWUyMDBhYjFlZjM4' +
				'OTQwMzhlNDg0ODViMTNmODM4N2UyMDU5NzkwOGEyYzE3ZTBhZTBkIn0.eyJhdWQiOiIyIiwianRpIjoiOTM4MGIzOGIzYWUzMGV' +
				'iZDllNjcyOGVjYmM1YWM5ZTIwMGFiMWVmMzg5NDAzOGU0ODQ4NWIxM2Y4Mzg3ZTIwNTk3OTA4YTJjMTdlMGFlMGQiLCJpYXQiOj' +
				'E1OTMwOTcxMTEsIm5iZiI6MTU5MzA5NzExMSwiZXhwIjoxNTk1Njg5MTExLCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.eTs01Oe7K' +
				'Q_-fSjK7nKZyYcAZvplkFQ9qqQ_hHKvk1cmT7zkCRezkmUsC7P50B5FvMdbuSxCRCU9hvU1Tss52-YGbyNyAA2sBABcA-mswoGi' +
				'pf1irH_JAPwifNraCPGNZbmIkmAU4ySoIm4lu_zPX5ycTnPoZnUWpkWx4FJVyPzXWcpsHjJVownvA3rTr1xOtfbbef7_lRABItG' +
				'Z0MIo6smzknX2MDxOu2Zzt4cAPd86aOGyaTnYEXPeVJmr3_dlZR4xwCca5Jac2UjMomZJya0jeDcscVtxXmRbbXzeSPQW85ZGEp' +
				'7iVf6VbBAD-N0Isd2qf_FSuDj2EWowiKyy2sVZ15OZuMhnJGxTpFC8RK3cfucgNyWeJ-LR3ivnjzrDe-UdP2vShfu95zcX4WvfX' +
				'3EGPkBVItWbJEBcaQZUAdszkT9elwW0GswXd1zlxejSydATu47r_garAmq6815MdAV8ImoiuyHic7zlABvfRYPKGeJbh0OcENBP' +
				'VQ4MBJiM5CgHB_NcXIGkgTqQNarDcpOhIglSF15OX2TFJQIMT5R9q_hO6kjAmRzMhLhL4fSEjf3Tkv3eNGa9SowpOZrzf5-g90E' +
				'RHtGyXApcuRerEOgZzEwaMqk-CpM0kGP6n6N9mfqNTX_WQgpLTnnQfOE7HNHuf5NWpY6D5CzVG6lNZN4';
	}
	public static String getRefreshToken() {
		return 'def50200bfb6e07f553cdf4125c5fe9a90fe13fc88eede9b37159d5058ff55a765af4c78346758d7e570356ef907d5d456fa' +
				'e7f7e510716ad3fa0c4e94598465f9af523b3ecefd5001cae72387fe3ba195ff3b7760b44b171796260a5295eb2566fd555' +
				'd4de38d59b14e12bbf9d99b4662fd4c1e271b30ec9697fb132fc8d1a0c1dc9de41712c1142dc91e61bccfb15f0ec785a697' +
				'332d0c7332072735e8e8d406b2112291afd650516f41c625d20094017fb20d7cad2af2ed4eaccd60ada74c1d225ad0c6559' +
				'700070471d0f99be143e8df93663226eaecbaab0a610fa4e1c0da41b71119a6a557499ec983b72b91cb0aefcab8e7a23d07' +
				'95e0cd61bbc163c388981447dca262c90127ba7196688227a15a28269dc637b8d8f902f340b21d24afb2d7a4352df7003dd' +
				'890c72e4426eca95ae621ff9b783b1734559773df43dbd93135ac91b987ece4a024d9bc41912f4661fd1fe1956a38c07903' +
				'489e4e73effa';
	}
	public static String getValue1() {
		return
			'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjkzODBiMzhiM2FlMzBlYmQ5ZTY3MjhlY2JjNWFjOWUyMDB' +
			'hYjFlZjM4OTQwMzhlNDg0ODViMTNmODM4N2UyMDU5NzkwOGEyYzE3ZTBhZTBkIn0.eyJhdWQiOiIyIiwianRpIjoiOT' +
			'M4MGIzOGIzYWUzMGViZDllNjcyOGVjYmM1YWM5ZTIwMGFiMWVmMzg5NDAzOGU0ODQ4NWIxM2Y';
	}
	public static String getValue2() {
		return
			'4Mzg3ZTIwNTk3OTA4YTJjMTdlMGFlMGQiLCJpYXQiOjE1OTMwOTcxMTEsIm5iZiI6MTU5MzA5NzExMSwiZXhwIjoxNT' +
			'k1Njg5MTExLCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.eTs01Oe7KQ_-fSjK7nKZyYcAZvplkFQ9qqQ_hHKvk1cmT7zkC' +
			'RezkmUsC7P50B5FvMdbuSxCRCU9hvU1Tss52-YGbyNyAA2sBABcA-mswoGipf1irH_JAPwifN';
	}
	public static String getValue3() {
		return
			'raCPGNZbmIkmAU4ySoIm4lu_zPX5ycTnPoZnUWpkWx4FJVyPzXWcpsHjJVownvA3rTr1xOtfbbef7_lRABItGZ0MIo6' +
			'smzknX2MDxOu2Zzt4cAPd86aOGyaTnYEXPeVJmr3_dlZR4xwCca5Jac2UjMomZJya0jeDcscVtxXmRbbXzeSPQW85ZG' +
			'Ep7iVf6VbBAD-N0Isd2qf_FSuDj2EWowiKyy2sVZ15OZuMhnJGxTpFC8RK3cfucgNyWeJ-LR3';
	}
	public static String getValue4() {
		return
			'ivnjzrDe-UdP2vShfu95zcX4WvfX3EGPkBVItWbJEBcaQZUAdszkT9elwW0GswXd1zlxejSydATu47r_garAmq6815M' +
			'dAV8ImoiuyHic7zlABvfRYPKGeJbh0OcENBPVQ4MBJiM5CgHB_NcXIGkgTqQNarDcpOhIglSF15OX2TFJQIMT5R9q_h' +
			'O6kjAmRzMhLhL4fSEjf3Tkv3eNGa9SowpOZrzf5-g90ERHtGyXApcuRerEOgZzEwaMqk-CpM0';
	}
	public static String getValue5() {
		return 'kGP6n6N9mfqNTX_WQgpLTnnQfOE7HNHuf5NWpY6D5CzVG6lNZN4';
	}
	public static String getRefreshValue1() {
		return
			'def50200bfb6e07f553cdf4125c5fe9a90fe13fc88eede9b37159d5058ff55a765af4c78346758d7e570356ef' +
			'907d5d456fae7f7e510716ad3fa0c4e94598465f9af523b3ecefd5001cae72387fe3ba195ff3b7760b44b17' +
			'1796260a5295eb2566fd555d4de38d59b14e12bbf9d99b4662fd4c1e271b30ec9697fb132fc8d1a';
	}
	public static String getRefreshValue2() {
		return
			'0c1dc9de41712c1142dc91e61bccfb15f0ec785a697332d0c7332072735e8e8d406b2112291afd650516f41c6' +
			'25d20094017fb20d7cad2af2ed4eaccd60ada74c1d225ad0c6559700070471d0f99be143e8df93663226eae' +
			'cbaab0a610fa4e1c0da41b71119a6a557499ec983b72b91cb0aefcab8e7a23d0795e0cd61bbc163';
	}

}