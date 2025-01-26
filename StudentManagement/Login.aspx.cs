using System;
using System.Data.SqlClient;

namespace StudentManagement
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text;
            string password = txtPassword.Text;

            // Admin login check
            if (username == "admin" && password == "0000")
            {
                Session["AdminAuthenticated"] = true;
                Response.Redirect("~/Admin.aspx");
                return;
            }

            // Student login logic
            string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\Data.mdf;Integrated Security=True";
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT Password, StudentID FROM Student WHERE Username = @Username", conn);
                cmd.Parameters.AddWithValue("@Username", username);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    string dbPassword = reader["Password"].ToString();
                    int studentID = Convert.ToInt32(reader["StudentID"]);

                    if (dbPassword == password)
                    {
                        Session["StudentID"] = studentID;
                        Response.Redirect("~/Profile.aspx");
                    }
                    else
                    {
                        lblMessage.Text = "Invalid username or password.";
                    }
                }
                else
                {
                    lblMessage.Text = "Invalid username or password.";
                }
            }
        }

        protected void btnSignUp_Click(object sender, EventArgs e)
        {
            string fullName = txtSignupFullName.Text;
            string email = txtSignupEmail.Text;
            string username = txtSignupUsername.Text;
            string password = txtSignupPassword.Text;

            string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\Data.mdf;Integrated Security=True";
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("INSERT INTO Student (FullName, Email, Username, Password) VALUES (@FullName, @Email, @Username, @Password)", conn);
                cmd.Parameters.AddWithValue("@FullName", fullName);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Password", password);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    lblSignupMessage.Text = "Sign-up successful!";
                }
                catch (SqlException ex)
                {
                    lblSignupMessage.Text = "Error: " + ex.Message;
                }
            }
        }

        protected void btnInsertCourses_Click(object sender, EventArgs e)
        {
            string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\Data.mdf;Integrated Security=True";
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();

                    // Insert 7 courses
                    SqlCommand cmdInsert = new SqlCommand(@"
                        INSERT INTO Course (CourseName, Instructor, Credits)
                        VALUES 
                        ('Mathematics', 'Dr. Smith', 3),
                        ('Physics', 'Prof. Johnson', 4),
                        ('Chemistry', 'Dr. Brown', 3),
                        ('Biology', 'Prof. Davis', 4),
                        ('Computer Science', 'Dr. Wilson', 3),
                        ('History', 'Prof. Moore', 2),
                        ('Literature', 'Dr. Taylor', 2)", conn);

                    int rowsAffected = cmdInsert.ExecuteNonQuery();
                    lblMessage.Text = $"{rowsAffected} courses inserted successfully!";
                }
                catch (SqlException ex)
                {
                    lblMessage.Text = "Error: " + ex.Message;
                }
                finally
                {
                    conn.Close();
                }
            }
        }
    }
}