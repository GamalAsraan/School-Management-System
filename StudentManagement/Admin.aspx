<%@ Page Title="Admin" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="StudentManagement.Admin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .section {
            margin: 20px;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
        }
        .form-group input[type="text"],
        .form-group input[type="password"],
        .form-group input[type="number"] {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .error-message {
            color: red;
            margin-top: 10px;
        }
        .success-message {
            color: green;
            margin-top: 10px;
        }
        .grid-view {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }
        .grid-view th,
        .grid-view td {
            padding: 8px;
            border: 1px solid #ddd;
            text-align: left;
        }
        .grid-view th {
            background-color: #f5f5f5;
        }
        .btn {
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            border: none;
        }
        .btn-primary {
            background-color: #4CAF50;
            color: white;
        }
        .btn-primary:hover {
            background-color: #45a049;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn-danger:hover {
            background-color: #c82333;
        }
        .logout-btn {
            float: right;
            margin: 10px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="pnlLogin" runat="server" Visible="true">
        <div class="section">
            <h2>Admin Login</h2>
            <div class="form-group">
                <asp:Label runat="server" AssociatedControlID="txtAdminPassword">Password:</asp:Label>
                <asp:TextBox ID="txtAdminPassword" runat="server" TextMode="Password"></asp:TextBox>
            </div>
            <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary" OnClick="btnLogin_Click" />
            <asp:Label ID="lblLoginError" runat="server" CssClass="error-message"></asp:Label>
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlAdminContent" runat="server" Visible="false">
        
        <!-- Section 1: Welcome Message -->
        <div class="section">
            <h2>Welcome, Gamal Asran</h2>
        </div>

        <!-- Section 2: Insert New Course -->
        <div class="section">
            <h2>Insert New Course</h2>
            <div class="form-group">
                <label for="txtCourseName">Course Name:</label>
                <asp:TextBox ID="txtCourseName" runat="server" required="true"></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtInstructor">Instructor:</label>
                <asp:TextBox ID="txtInstructor" runat="server" required="true"></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtCredits">Credits:</label>
                <asp:TextBox ID="txtCredits" runat="server" required="true" TextMode="Number"></asp:TextBox>
            </div>
            <asp:Button ID="btnInsertCourse" runat="server" Text="Insert Course" CssClass="btn btn-primary" OnClick="btnInsertCourse_Click" />
            <asp:Label ID="lblMessage" runat="server" CssClass="error-message"></asp:Label>
            <asp:Label ID="lblSuccess" runat="server" CssClass="success-message"></asp:Label>
        </div>

        <!-- Section 3: Display and Delete Courses -->
        <div class="section">
            <h2>Course List</h2>
            <asp:GridView ID="gvCourses" runat="server" CssClass="grid-view" AutoGenerateColumns="false" 
                         OnRowCommand="gvCourses_RowCommand" AlternatingRowStyle-BackColor="#f9f9f9">
                <Columns>
                    <asp:BoundField DataField="CourseID" HeaderText="Course ID" />
                    <asp:BoundField DataField="CourseName" HeaderText="Course Name" />
                    <asp:BoundField DataField="Instructor" HeaderText="Instructor" />
                    <asp:BoundField DataField="Credits" HeaderText="Credits" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:Button runat="server" CommandName="DeleteCourse" Text="Delete" 
                                      CssClass="btn btn-danger" CommandArgument='<%# Eval("CourseID") %>'
                                      OnClientClick="return confirm('Are you sure you want to delete this course and all related student records?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </asp:Panel>
</asp:Content>