// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application";

import ApplicationController from "./application_controller";
import { Autocomplete } from "stimulus-autocomplete";
import WelcomeController from "./welcome_controller";
import ArticleController from "./article_controller";
import AuthorController from "./author_controller";
import FlatpickrController from "./flatpickr_controller";
import UserProfileController from "./user_profile_controller";
import ThemeChapterController from "./theme_chapter_controller";
import SearchController from "./search_controller";
//import DashboardController from "./dashboard_controller";
import AdminAuthorController from "./admin/author_controller";
import AdminContextController from "./admin/context_controller";
import AdminArticleController from "./admin/article_controller";
import AdminTagController from "./admin/tag_controller";
import SidebarController from "./sidebar_controller";
import CommentController from "./comment_controller";
import CommentReportingController from "./comment_reporting_controller";

application.register('application', ApplicationController);
application.register('autocomplete', Autocomplete);
application.register("welcome", WelcomeController);
application.register("article", ArticleController);
application.register("author", AuthorController);
application.register("flatpickr", FlatpickrController);
application.register("userprofile", UserProfileController);
application.register("themechapter", ThemeChapterController);
application.register("search", SearchController);
application.register("admin-author", AdminAuthorController);
application.register("admin-context", AdminContextController);
application.register("admin-article", AdminArticleController);
application.register("sidebar", SidebarController);
application.register("comment", CommentController);
application.register("comment-reporting", CommentReportingController);
application.register("admin-tag", AdminTagController);
//application.register("dashboard", DashboardController);