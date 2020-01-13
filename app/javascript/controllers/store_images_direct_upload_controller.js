import { Controller } from "stimulus";
import Uploader from 'libs/uploader';

export default class extends Controller {
    start(event) {
        const { target } = event;
        [...target.files].forEach(file => {
          // 準備 image 容器與 progress bar
          let wrapper = document.createElement('div');
          wrapper.classList.add('img-wrapper');
          wrapper.insertAdjacentHTML('afterbegin', `
            <div class="progress">
              <div class="progress-bar" style="width: 0%;"></div>
            </div>
          `);
          $("#store_images_preview_region").append(wrapper);
          // 開始上傳
          const directUploadUrl = $("#update_info_div").attr("data-uploads-direct-upload-url");          
          const store_id        = $("#update_info_div").attr("info-store-id");
          const meta_csrf       = $("meta[name='csrf-token']").attr("content");
          const uploader        = new Uploader(file, directUploadUrl, wrapper);          
          uploader.upload()
            .then(blob => {
              // 更新資料庫
              fetch(`/update_store_pictures/${store_id}.json`, {
                headers: {
                  'X-CSRF-Token': meta_csrf,
                  'Content-Type': 'application/json',
                  'X-Requested-With': 'XMLHttpRequest'
                },
                method: 'POST',
                body: JSON.stringify({
                  store: {
                    store_images: [blob.signed_id]
                  }
                }),
                credentials: 'same-origin'
              })
              .then(res => res.json())
              .then(data => {
                wrapper.innerHTML = `
                  <div class="lds-dual-ring"></div>
                `;

                let img = document.createElement('img');
                img.src = data.url;
                img.onload = () => {
                  wrapper.innerHTML = '';
                  wrapper.appendChild(img);
                  wrapper.insertAdjacentHTML('beforeend', `
                    <a href="/delete_store_picture/${store_id}/store_picture/${data.id}"
                      data-action="click->store-images-direct-upload#destroy">
                      刪除
                    </a>
                  `);
                };
                $("#upload_message").html("上傳圖片成功")
              });
            });
        });
        target.value = '';
    }


    destroy(event) {    
        event.preventDefault();
        const url  = $(event.target).attr("href");
        const meta_csrf = $("meta[name='csrf-token']").attr("content");
        fetch(url, {
          headers: {
            'X-CSRF-Token': meta_csrf,
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
          },
          method: 'GET',
          credentials: 'same-origin'          
        })
        .then(res => res.json())
        .then(data => {
            $(event.target).parent(".img-wrapper").remove();
            $("#upload_message").html("刪除圖片成功") 
        });
      }
    
  
}