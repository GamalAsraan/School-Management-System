using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StudentManagement
{
    public partial class Profile : System.Web.UI.Page
    {
        private readonly string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\Data.mdf;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["StudentID"] == null)
            {
                Response.Redirect("Login.aspx", true);
                return;
            }

            if (!IsPostBack)
            {
                LoadWelcomeMessage();
                LoadRegisteredCourses();
                LoadAvailableCourses();
            }
        }

        private void LoadWelcomeMessage()
        {
            try
            {
                int studentID = Convert.ToInt32(Session["StudentID"]);
                using (var conn = new SqlConnection(connectionString))
                using (var cmd = new SqlCommand("SELECT FullName FROM Student WHERE StudentID = @StudentID", conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentID);
                    conn.Open();
                    var fullName = cmd.ExecuteScalar()?.ToString() ?? "Student";
                    lblWelcome.Text = Server.HtmlEncode(fullName);
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading profile: " + Server.HtmlEncode(ex.Message);
            }
        }

        private void LoadRegisteredCourses()
        {
            try
            {
                int studentID = Convert.ToInt32(Session["StudentID"]);
                using (var conn = new SqlConnection(connectionString))
                using (var cmd = new SqlCommand(@"
                    SELECT c.CourseID, c.CourseName, c.Instructor, c.Credits 
                    FROM Course c
                    INNER JOIN StudentCourse sc ON c.CourseID = sc.CourseID
                    WHERE sc.StudentID = @StudentID", conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentID);
                    using (var da = new SqlDataAdapter(cmd))
                    {
                        var dt = new DataTable();
                        da.Fill(dt);
                        gvRegisteredCourses.DataSource = dt;
                        gvRegisteredCourses.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading courses: " + Server.HtmlEncode(ex.Message);
            }
        }

        private void LoadAvailableCourses()
        {
            try
            {
                int studentID = Convert.ToInt32(Session["StudentID"]);
                using (var conn = new SqlConnection(connectionString))
                using (var cmd = new SqlCommand(@"
                    SELECT c.CourseID, c.CourseName, c.Instructor, c.Credits 
                    FROM Course c
                    WHERE c.CourseID NOT IN (
                        SELECT CourseID FROM StudentCourse WHERE StudentID = @StudentID
                    )", conn))
                {
                    cmd.Parameters.AddWithValue("@StudentID", studentID);
                    using (var da = new SqlDataAdapter(cmd))
                    {
                        var dt = new DataTable();
                        da.Fill(dt);
                        gvAvailableCourses.DataSource = dt;
                        gvAvailableCourses.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading available courses: " + Server.HtmlEncode(ex.Message);
            }
        }

        protected void gvRegisteredCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DropCourse")
            {
                try
                {
                    int courseID = Convert.ToInt32(e.CommandArgument);
                    int studentID = Convert.ToInt32(Session["StudentID"]);

                    using (var conn = new SqlConnection(connectionString))
                    using (var cmd = new SqlCommand("DELETE FROM StudentCourse WHERE StudentID = @StudentID AND CourseID = @CourseID", conn))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentID);
                        cmd.Parameters.AddWithValue("@CourseID", courseID);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        LoadRegisteredCourses();  // Refresh registered courses
                        LoadAvailableCourses();   // Refresh available courses
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error dropping course: " + Server.HtmlEncode(ex.Message);
                }
            }
        }

        protected void gvAvailableCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "RegisterCourse")
            {
                try
                {
                    int courseID = Convert.ToInt32(e.CommandArgument);
                    int studentID = Convert.ToInt32(Session["StudentID"]);

                    using (var conn = new SqlConnection(connectionString))
                    using (var cmd = new SqlCommand("INSERT INTO StudentCourse (StudentID, CourseID) VALUES (@StudentID, @CourseID)", conn))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentID);
                        cmd.Parameters.AddWithValue("@CourseID", courseID);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        LoadRegisteredCourses();
                        LoadAvailableCourses();
                    }
                }
                catch (SqlException ex)
                {
                    if (ex.Number == 547)
                    {
                        lblMessage.Text = "Error: Invalid course registration.";
                    }
                    else
                    {
                        lblMessage.Text = "Database error: " + Server.HtmlEncode(ex.Message);
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error registering course: " + Server.HtmlEncode(ex.Message);
                }
            }
        }

        protected void btnDeleteAllData_Click(object sender, EventArgs e)
        {
            try
            {
                int studentID = Convert.ToInt32(Session["StudentID"]);
                using (var conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    using (var transaction = conn.BeginTransaction())
                    {
                        try
                        {
                            using (var cmd1 = new SqlCommand("DELETE FROM StudentCourse WHERE StudentID = @StudentID", conn, transaction))
                            using (var cmd2 = new SqlCommand("DELETE FROM Student WHERE StudentID = @StudentID", conn, transaction))
                            {
                                cmd1.Parameters.AddWithValue("@StudentID", studentID);
                                cmd2.Parameters.AddWithValue("@StudentID", studentID);

                                cmd1.ExecuteNonQuery();
                                cmd2.ExecuteNonQuery();

                                transaction.Commit();
                            }
                        }
                        catch
                        {
                            transaction.Rollback();
                            throw;
                        }
                    }
                }

                Session.Clear();
                Response.Redirect("Login.aspx", true);
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error deleting data: " + Server.HtmlEncode(ex.Message);
            }
        }
    }
}