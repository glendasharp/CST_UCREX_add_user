package edu.ucsf.ars;
//import java.text.ParseException;
import java.util.logging.Logger;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class I2B2Manager extends CohortManager {


		private static final String COUNT_ADD_USER_IMPORTS = "select count(*) from I2B2PM.AD_USER_IMPORTS";
		private static final String CREATE_ACCTS_CAMPUS = "begin i2b2pm.i2b2_mass_user_import; end;";
		private static final String CREATE_ACCTS_SOM = "begin i2b2pm.i2b2_som_user_import; end;";
		private static final String CREATE_ACCTS_MEDCTR = "begin i2b2pm.i2b2_ucsfmc_user_import; end;";

		private static final String INSERT_ACCT = "insert into I2B2PM.AD_USER_IMPORTS (USER_ID,PROJECT_ID,USER_ROLE_CD, FULL_NAME,EMAIL,EMPLOYEE_ID) values(?,?,?,?,?,?)";

		private static final String DELETE_ACCTS = "delete from I2B2PM.AD_USER_IMPORTS";
		private static final String SELECT_BY_USER = "select * from I2B2PM.AD_USER_IMPORT_ARCHIVE where USER_ID = ?";
		private String url;
		private String username;
		private String password;
		private UcsfDomain domain;
		private Logger logger;
		private Connection connection;
		private PreparedStatement pstmt;

		public I2B2Manager(String url, String username, String password, UcsfDomain domain,
				Logger logger) {

			this.url = url;
			this.username = username;
			this.password = password;
			this.domain = domain;
			this.logger = logger;
			this.connection = openConnection();
		}

		// protected void finalize() {
		// try {
		// if (!this.connection.isClosed())
		// this.connection.close();
		// } catch (SQLException e) {
		// logger.severe(e.getMessage());
		// e.printStackTrace();
		// }
		// }

		public String getUrl() {
			return url;
		}

		public void setUrl(String url) {
			this.url = url;
		}

		public String getUsername() {
			return username;
		}

		public void setUsername(String username) {
			this.username = username;
		}

		public String getPassword() {
			return password;
		}

		public void setPassword(String password) {
			this.password = password;
		}

		public Logger getLogger() {
			return logger;
		}

		public void setLogger(Logger logger) {
			this.logger = logger;
		}

		public Connection getConnection() {
			return connection;
		}

		public void setConnection(Connection connection) {
			this.connection = connection;
		}

		private Connection openConnection() {
			Connection conn = null;
			try {
				Class.forName("oracle.jdbc.OracleDriver");

				conn = DriverManager.getConnection(this.url, this.username,
						this.password);
			} catch (ClassNotFoundException e) {
				logger.severe(e.getMessage());
			} catch (SQLException e) {
				logger.severe(e.getMessage());
			}
			return conn;

		}

		public int countAddUserImports() {
			int count = 0;
			ResultSet rs = executeQuery(COUNT_ADD_USER_IMPORTS);
			try {
				if (rs.next())
					count = rs.getInt(1);
				rs.close();
			} catch (SQLException e) {
				logger.severe(e.getMessage());
				e.printStackTrace();
			}
			return count;
		}

		public boolean isAcctCreated(String userId) {
			boolean found = false;
			try {
				pstmt = connection.prepareStatement(SELECT_BY_USER);
				pstmt.setString(1, userId.toLowerCase());
				pstmt.execute();
				ResultSet rs = pstmt.getResultSet();
				if (rs.next())
					found = true;
				pstmt.close();
			} catch (SQLException e) {
				logger.severe(e.getMessage());
				e.printStackTrace();
			}
			
			return found;
		}

		public void createAccts() {
			CallableStatement cs = null;
			try {
				if(domain == UcsfDomain.CAMPUS) 
					cs = connection.prepareCall(CREATE_ACCTS_CAMPUS);
				if(domain == UcsfDomain.SOM) 
					cs = connection.prepareCall(CREATE_ACCTS_SOM);
				if(domain == UcsfDomain.MEDCTR) 
					cs = connection.prepareCall(CREATE_ACCTS_MEDCTR);

				cs = connection.prepareCall(CREATE_ACCTS_CAMPUS);
				cs.execute();
			} catch (SQLException e) {
				logger.severe(e.getMessage());
				e.printStackTrace();
			} finally {
				try {
					cs.close();
				} catch (SQLException e) {
					logger.severe(e.getMessage());
					e.printStackTrace();
				}
			}

		}

		public void insertNewAcct(String userId, String projectId, String userRole,
				String fullName, String email, String employeeId) {
			try {
				pstmt = connection.prepareStatement(INSERT_ACCT);
				pstmt.setString(1, userId.toLowerCase());
				pstmt.setString(2, projectId);
				pstmt.setString(3, userRole);
				pstmt.setString(4, fullName);
				if (email == null)
					pstmt.setNull(5, java.sql.Types.VARCHAR);
				else
					pstmt.setString(5, email);
				if (employeeId == null)
					pstmt.setNull(6, java.sql.Types.VARCHAR);
				else
					pstmt.setString(6, employeeId);
				pstmt.executeUpdate();
				pstmt.close();

			} catch (SQLException e) {
				logger.severe(e.getMessage());
				e.printStackTrace();
			} finally {
//				try {
//					if (pstmt != null && !pstmt.isClosed())
//						pstmt.close();
//				} catch (SQLException e) {
//					logger.severe(e.getMessage());
//					e.printStackTrace();
//				}
			}
		}

		public void deleteAccts() {
			try {
				pstmt = connection.prepareStatement(DELETE_ACCTS);
				pstmt.executeUpdate();
				pstmt.close();
			} catch (SQLException e) {
				logger.severe(e.getMessage());
				e.printStackTrace();
			} finally {
//				try {
//					if (pstmt != null && !pstmt.isClosed())
//						pstmt.close();
//				} catch (SQLException e) {
//					logger.severe(e.getMessage());
//					e.printStackTrace();
//				}
			}
		}

		private ResultSet executeQuery(String query) {
			ResultSet rs = null;
			try {
				Statement stmt = connection.createStatement();
				rs = stmt.executeQuery(query);
			} catch (SQLException e) {
				logger.severe(e.getMessage());
				e.printStackTrace();
			}
			return rs;
		}


}

