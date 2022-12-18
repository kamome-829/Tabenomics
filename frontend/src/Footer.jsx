import "./Footer.css";

export const Footer = () => {
  return (
    <footer
      id="footer-section"
      style={{
        background: `url(
          "https://markdoor.net/pecopecopenguin/wp-content/uploads/2022/11/スクリーンショット-2022-11-19-235629.png"
        )`,
        backgroundSize: `cover`,
      }}
    >
      <div className="footer-content">
        <div className="footer-main">
          <div className="row-content">
            <div className="icon">
              <a href="./">
                <img src="https://markdoor.net/pecopecopenguin/wp-content/plugins/burger-companion/inc/appetizer/images/icon_gif/footer-above-info/avatar-calm-approved.gif" />
              </a>
            </div>
            <div className="footer-info">
              <a href="./">Privacy Policy</a>
            </div>
          </div>
          <div className="row-content">
            <div className="icon">
              <a href="./">
                <img
                  src="https://markdoor.net/pecopecopenguin/wp-content/plugins/burger-companion/inc/appetizer/images/icon_gif/footer-above-info/shield-security.gif"
                  alt="利用規約"
                />
              </a>
            </div>
            <div className="footer-info">
              <a href="./">利用規約</a>
            </div>
          </div>
          <div className="row-content">
            <div className="icon">
              <a href="./">
                <img
                  src="https://markdoor.net/pecopecopenguin/wp-content/plugins/burger-companion/inc/appetizer/images/icon_gif/footer-above-info/gift.gif"
                  alt="利用規特定商取引法に基づく表記"
                />
              </a>
            </div>
            <div className="footer-info">
              <a href="./">利用規約・特定商取引法に基づく表記</a>
            </div>
          </div>
          <div className="row-content">
            <div className="icon">
              <a href="./">
                <img
                  src="https://markdoor.net/pecopecopenguin/wp-content/uploads/2022/11/小見出しを追加-300x300.png"
                  alt="運営会社"
                />
              </a>
            </div>
            <div className="footer-info">
              <a href="./">運営会社 Mark Doorについて</a>
            </div>
          </div>
        </div>
        <div className="footer-copyright">
          <div className="copyright">
            Copyright © 2022 Peco Peco Penguin |<br></br> Powered by Appetizer
          </div>
          <div className="contact">
            <div>
              <a href="./">お問い合わせ</a>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
};
