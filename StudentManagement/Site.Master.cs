using System;
using System.Web.UI;

namespace StudentManagement
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Always check session state (not just on initial load)
            if (Session["AdminAuthenticated"] != null && (bool)Session["AdminAuthenticated"])
            {
                hlAdmin.Visible = true;
            }
            else
            {
                hlAdmin.Visible = false;
            }
        }
    }
}