import "./PostSection.css";
import Select from 'react-select';
import { useContext } from "react";
import { TransactionContext } from './context/TransactionContext';

const options = [
  { value: 1, label: "1Mint" },
  { value: 2, label: "2Mint" },
  { value: 3, label: "3Mint" },
];

export const PostSection = () => {
  const {connectWallet, getamount, Quantity, Usermint}  = useContext(TransactionContext);

  const handleSubmit = () => {
    const amount = Quantity;
    if(amount == 0){
      return;
    }else{
      Usermint(amount);
      //console.log(amount);
    }
  };

  return (
    <div>
      <section className="post-section">
        <div className="container">
          <article className="post-items">
            <div className="post-content">
              <div className="post-item" id="first-item">
                <h2>PPPとは</h2>
              </div>
              <div className="post-item" id="second-item">
                <h2>PPPの特徴</h2>
                <div className="post-item-wrapper">
                  <ul className="post-second-list">
                    <li className="post-second-list-item">
                      <div className="post-second-image-container">
                        <img src="https://markdoor.net/pecopecopenguin/wp-content/uploads/2022/11/profile_img-300x300.png" />
                      </div>
                      <div className="post-second-text-container">
                        <p>芸能人/著名人も参加する食コミュニティ</p>
                      </div>
                    </li>
                    <li className="post-second-list-item">
                      <div className="post-second-image-container">
                        <img src="https://markdoor.net/pecopecopenguin/wp-content/uploads/2022/11/スクリーンショット-2022-11-28-080412-300x294.png" />
                      </div>
                      <div className="post-second-text-container">
                        <p>NFTを出したい飲食店の支援</p>
                      </div>
                    </li>
                    <li className="post-second-list-item">
                      <div className="post-second-image-container">
                        <img src="https://markdoor.net/pecopecopenguin/wp-content/uploads/2022/11/スクリーンショット-2022-11-28-074659-1-300x294.png" />
                      </div>
                      <div className="post-second-text-container">
                        <p>会員限定レビューの公開/食べ物勝手にコンテスト実施</p>
                      </div>
                    </li>
                  </ul>
                </div>
              </div>
              <div className="post-item" id="third-item">
                    <div className="block-fome">
                        <Select  options={options} onChange={(e) => getamount(e.value)}/>
                    </div>
                <div className="block-button-container">
                  <div  onClick={handleSubmit} className="block-button">
                    <a className="block-button-link">
                      <strong>Mint</strong>
                    </a>
                  </div>
                </div>
              </div>

              <div className="post-item" id="fourth-item">
                <div className="icons">
                  <div className="icon-container">
                    <a href="./" className="discord-link">
                      <img
                        className="discord-image"
                        src="https://markdoor.net/pecopecopenguin/wp-content/uploads/2022/11/ダウンロード-1.png"
                      />
                    </a>
                  </div>
                  <div className="icon-container">
                    <a href="./" className="twitter-link">
                      <img
                        className="twitter-image"
                        src="https://markdoor.net/pecopecopenguin/wp-content/uploads/2022/11/ダウンロード-2.png"
                      />
                    </a>
                  </div>
                </div>
              </div>

              <div className="post-item" id="fifth-item">
                <div className="block-button-row">
                  <div className="fifth-post-button-container">
                    <a href="./" className="row-button-link">
                      <strong>ご購入はこちら☚</strong>
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </article>
        </div>
      </section>
    </div>
  );
};

