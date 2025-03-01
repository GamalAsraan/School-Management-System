﻿using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StudentManagement
{
    public partial class Admin : System.Web.UI.Page
    {
        private readonly string connectionString = @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\Data.mdf;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect to login if not authenticated
            if (Session["AdminAuthenticated"] == null || !(bool)Session["AdminAuthenticated"])
            {
                Response.Redirect("~/Login.aspx");
            }

            // Bind GridView on initial load
            if (!IsPostBack)
            {
                BindGridView();
            }
        }

        // Insert Course
        protected void btnInsertCourse_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        string query = "INSERT INTO Course (CourseName, Instructor, Credits) VALUES (@CourseName, @Instructor, @Credits)";
                        SqlCommand cmd = new SqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@CourseName", txtCourseName.Text);
                        cmd.Parameters.AddWithValue("@Instructor", txtInstructor.Text);
                        cmd.Parameters.AddWithValue("@Credits", int.Parse(txtCredits.Text));
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                        lblSuccess.Text = "Course inserted successfully!";
                        lblMessage.Text = "";
                        BindGridView(); // Refresh the GridView
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "An error occurred. Please try again later.";
                    lblSuccess.Text = "";
                }
            }
        }

        // Delete Course
        protected void gvCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteCourse")
            {
                int courseID = Convert.ToInt32(e.CommandArgument);
                try
                {
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();

                        // Step 1: Delete related records in the StudentCourse table
                        string deleteStudentCourseQuery = "DELETE FROM StudentCourse WHERE CourseID = @CourseID";
                        SqlCommand deleteStudentCourseCmd = new SqlCommand(deleteStudentCourseQuery, conn);
                        deleteStudentCourseCmd.Parameters.AddWithValue("@CourseID", courseID);
                        deleteStudentCourseCmd.ExecuteNonQuery();

                        // Step 2: Delete the course from the Course table
                        string deleteCourseQuery = "DELETE FROM Course WHERE CourseID = @CourseID";
                        SqlCommand deleteCourseCmd = new SqlCommand(deleteCourseQuery, conn);
                        deleteCourseCmd.Parameters.AddWithValue("@CourseID", courseID);
                        deleteCourseCmd.ExecuteNonQuery();

                        conn.Close();

                        lblSuccess.Text = "Course and related student records deleted successfully!";
                        lblMessage.Text = "";
                        BindGridView(); // Refresh the GridView
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "An error occurred. Please try again later.";
                    lblSuccess.Text = "";
                }
            }
        }

        // Bind GridView with Course Data
        private void BindGridView()
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT CourseID, CourseName, Instructor, Credits FROM Course";
                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvCourses.DataSource = dt;
                gvCourses.DataBind();
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/Login.aspx");
        }
    }
}