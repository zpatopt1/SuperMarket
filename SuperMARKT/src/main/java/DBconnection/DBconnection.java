package DBconnection;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBconnection {
	private static final String URL ="jdbc:mysql://localhost:3306/supermercado";
	private static final String USER ="root";
	private static final String PASSWORD ="12345678";
	
	public static Connection getConnection() throws Exception
	{
		return DriverManager.getConnection(URL, USER, PASSWORD);
	}


}
