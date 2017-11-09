//
//  KGBaseViewController.m
//  Aerospace
//
//  Created by mac on 16/10/18.
//  Copyright © 2016年 王迪. All rights reserved.
//

#ifndef PepJapanese_NetWorkConstants_h
#define PepJapanese_NetWorkConstants_h



#endif

/**
 *  网络接口
 */

typedef enum _NetWorkAction
{
    /**
     *  账号信息相关
     */
    kNetWorkActionLogin = 0,                //登录
    KNetWorkYzmAction,                      //获取手机短信验证码
    KNetWorkYzmLogin,                       //手机验证码登录
    KNetWorkgetVideolist,                   //根据栏目获取视频信息（获取视频列表）
    KNetWorkgetVideoDetaillist,             //获取我的文章图片视频评论
    KNetworkWenDaContent,            //获取问答列表
    KNetworkWenDaComment,            //获取问答评论列表
    KNetworkWenAddWenDaComment,      //添加问答评论
    KNetworkWenAddWenDa,      //添加问答
    KNetworkWenAddDongTai,      //添加动态
    KNetworkGetUser,      //推荐用户
    KNetworkGetMyFangwen,//我的访问
    KNetworkGetGUANZHU, ///获取我的关注
    KNetworkAddGUANZHU,///添加关注
    KNetworkDelGuanZhu,///删除关注
    KNetworkDongTaiComment,            //获取动态评论列表
    KNetworkADDDongTaiComment,  ///添加动态评论
    KNetworkGetCategory,///获取分类列表
    KNetworGetUserINfo,///用户信息
    KNetworkGetMyApprove,                   //获取我的认证信息
    KNetworkGetShoppinglist,                //获取商品列表
    KnetworkGetMyDingdan,                   //获取我的订单
    KNetworkGetDeleteDingdan,               //删除订单
    kNetworkGetAllAddress,                  //获取用户所有的地址列表
    KNetworkGetShopAddress,                 //获取用户地址
    KNetworkGetDeleteAddress,               //删除地址
    
    
    KNetWrokGetVersion,                     //获取服务器版本号
    KNetWorkGetuserInfom,                   //获取用户资料
    KNetWorkResetPassword,                  //重置密码
    KNetWorkGetYZM,                         //获取验证码
    KNetWorkBangdingPhone,                  //绑定新手机号
    KNetWorkGetAllLanMuData,                //获取所有栏目
    KNetWorkLanMuData,                      //栏目列表数据
    KNetWorkGetSingleDetailContent,         //获取单页面栏目内容
    KNetworkHongdianCount,                  //保存用户标签（推送必须）
    KNetWorkUnreadCount,                    //栏目未浏览文章的数量据统计
    KNetWorkZGGBUnreadCount,                //政工干部未浏览文章数据统计
    KNetWorkZuzhijigou,
    KNetWorkPersonalzuzhiRelation,          //获取个人组织关系信息
    KNetWorkRelationChange,                 //党员关系转接
    KNetWorkRelationChangeRecorder,         //党员关系转接记录
    KNetWorkJiaonaSearch,                   //党费缴纳信息展示
    KNetWorkjgImg,                          //组织机构图展示
    KNetWorkMyCollection,                   //我的收藏
    KNetWorkMyHistory,                      //历史记录
    KNetWorkSexAnalyase,                    //党员的性别统计
    KNetWorkWenzhangAnalyase,               //党员的文章统计
    KNetWorkDeplomaAnalyase,                //党员的学历统计
    KNetWorkMinzuAnalyase,                  //党员的民族统计
    KNetWorkAgeAnalyase,                    //党员的年龄统计
    KNetWorkLuntanDangyuanquanAllData,      //论坛-党员圈
    KNetWorkshujuzidian,                    //数据字典
    KNetworkGetuserBiaoqian,                //获取用户标签
    KNetWorkMyjifen,                        //积分记录数量统计
    KNetWorkJifenChaxun,                    //积分查询
    KNetWorkShenpijilu,                     //审批记录
    KNetWorkYijianfankui,                   //意见反馈文字
    KNetworkYijianfankuiPhoto,              //意见反馈图片
    KNetworkCommentContent,                 //栏目内容评论
    KNetworkGetcommentData,                 //根据栏目获取评论数据
    KNetworkDianzan,                        //踩栏目或模型
    KNetworkzuixinxinde,                    //最新心得
    KNetworkmyXinde,                        //我的心得查询
    KNetworklearnRecord,                    //学习记录统计
    KNetworkchengjichaxun,                  //试卷成绩查询
    KNetworklearnRecordchaxun,              //学习记录列表
    KNetworkReceiveMsg,                     //我收到的消息
    KNetworkToupiaoData,                    //按照分类获取投票
    KNetworkmyJudjement,                    //我的评价
    KNetworkFabuTiezi,                      //发布帖子
    KNetworkgetshijuanContent,              //通过编码获取试卷
    KNetworkQunzuInformation,               //依据部门id获取聊天群组
    KNetworkMyFensi,                        //我的粉丝
    KNetworkmyDynamic,                      //我的动态
    KNetworkMySign,                         //我的签名
    KNetworkMyApprove,                      //我的认证状态
    KnetworkApplyApprove,                   //申请认证
    NNetworkUpdateUserInfo,                 //更新用户信息
    
    
    
    
    KNetWorkMessageGet,                     //发送手机验证码
    kNetWorkActionRegister,                 //账号注册
    kNetWorkActionChangePassword,           //重设密码
    kNetWorkActiondFindPassword,            //找回密码
    
    /**
     *
     */
    KNetWorkGetRoute,                       //获取行程
    KNetWorkSeatSelect,                     //生成座位图
    KNetWorkCheckIn,                        //值机，即选座位后上传DNS
    KNetWorkCancelCheckIn,                  //取消值机
    KNetworkBoardPass,                      //获取登机牌
    KNetworkGetReportWeather,               //我的行程中获取机场天气
    
    /**
     *赵银生处理的接口
     */
    KNetWorkCouldUserdTicketandCabin,      //机票可售仓位及价格----单程搜索
    KNetWorkSearchticketandCabinGoandBack, //往返搜索
    KNetWorkSearchticketandCabinMoretimes, //多程搜索
    KNetWorkTicketPolity,                  //退改签页面信息查询接口
    KNetWorkGoandBackServiceSearch,        //往返时候多种仓位组合
    KNetWorkCreateTicketOrder,             //订单创建接口
    KNetWorkSearchAllOrder,                //查询全部订单接口
    KNetWorkDeleteOrderById,               //删除订单
    KNetWorkThirdPartyRegister,            //第三方注册
    
    /**
     *第三方服务器请求，聚合数据
     */
    KThirdJHNetworkFightLineQuery,          //聚合数据-航班动态-航线查询
    KThirdJHNetworkTocityTime,              //我的行程中到达城市时间
    KThirdJHNetworkGetDynamicDetail,        //聚合数据-航班动态-航班查询
    KThirdJHNetworkGetAirportInform,        //聚合数据-航班动态-机场简介
}NetWorkAction;



typedef enum _NetWorkStatuCode
{
    /**
     *  公用错误编码
     */
    kNetWorkStatuCodeError = -1,                    //预留用来处理特殊情况
    kNetWorkStatuCodeSuccess = 0,                   //成功,0000
    kNetWorkStatuCodeUserNotExist = 8001,           //用户不存在
}NetWorkStatuCode;

typedef void(^HJMFailureBlock)(NSError *error);
typedef void(^HJMNetWorkSuccessBlock)(id message);

