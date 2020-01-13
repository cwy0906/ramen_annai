import { DirectUpload } from "@rails/activestorage";

export default class {
  constructor(file, url, element) {
    this.file = file;
    this.url = url;
    this.element = element;
    this.directUpload = new DirectUpload(this.file, this.url, this);
  }

  upload() {
    return new Promise((resolve, reject) => {
      this.directUpload.create((error, blob) => {
        if (error) {
          reject(error);
        } else {
          resolve(blob);
        }
      });
    });
  }

  directUploadWillStoreFileWithXHR(request) {
    request.upload.addEventListener("progress",
      event => this.directUploadDidProgress(event));
  }

  directUploadDidProgress(e) {
    let progress = this.element.querySelector('.progress-bar');
    progress.style.width = ((e.loaded / e.total) * 100) + '%';
  }
}