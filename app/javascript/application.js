import "@hotwired/turbo-rails"
import "trix"
import "@rails/actiontext"
import { Application } from "@hotwired/stimulus"
import PreviewController from "./controllers/preview_controller"

const application = Application.start()
application.register("preview", PreviewController)
