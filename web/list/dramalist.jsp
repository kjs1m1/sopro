<%@ page import="java.util.HashMap" %>
<%@ page import="vo.DramaBoard" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:useBean id="dramafdao" class="dao.dramaFactory" scope="session"/>

<%
    request.setCharacterEncoding("utf-8");

    String colname = request.getParameter("colname");
    String findtext = request.getParameter("findtext");

    if (colname == null || colname.equals(""))
        colname="selected";

    if (findtext == null || findtext.equals(""))
        findtext="";

            // 검색기능
    HashMap<String, String> searchList = new HashMap<>();
        //1. 해시맵을 선언하고
    searchList.put(colname, findtext);
    //2. 키 벨류로 받는데 (키:옵션테그 선택값 , 벨류 : 찾는단어(input))



    System.out.println("colname : " + colname);
    System.out.println("findtext : " + findtext);

    ArrayList<DramaBoard> dblists = dramafdao.dramaList(searchList);
            //해시맵ㅇ
    session.setAttribute("dblists", dblists);

%>
<html>
<head>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">

    <title>Drama</title>
    <style>
        body {
            width: 100%;
            margin: 0 auto;
        }

        .list {
            float: left
        }

        .list > h3 {
            margin: 10px 0 10px 30px;
            font-weight: bold
        }

        .list > ul {
            list-style: none;
            text-align: left;
            text-decoration-line: none;
        }

        .list > ul > li {
            text-align: left;
            margin-left: 8px;
        }

        .list > ul > li > a {
            color: #000000
        }
    </style>
</head>


<body>
<div class="container">
    <%@include file="layout/header.jsp" %>

    <div class="main">
        <div class="row">
            <div class="col-8" style="font-size: 25px; margin: 0 45px 0 50px ; padding:30px 0 20px 0;">
                <i class="fa fa-comments fa-2x"> Drama</i></div>
            <div class="col-3">
                <button type="button" class="btn btn-success" id="newbtn" style="margin:40px 0 15px 110px; ">
                    <i class="fa fa-plus-circle"> 새글쓰기</i>
                </button>
            </div>
        </div>

        <div class="row" style="margin: 10px 0 20px 0">
            <div class="list col-sm-3">
                <h3><i class="fa fa-handshake-o" aria-hidden="true"></i> 방송사</h3>
                <ul>
                    <%--해당 카테고리 a태그는 지워고 색깔 바꿔주세요--%>
                    <li><a href=">/catboard/catList.jsp">&block;&nbsp;&nbsp;KBS Drama</a></li>
                    <li style="color:#919191">&block;&nbsp;&nbsp;MBC Drama</li>
                    <li><a href="/reviewboard/revList.jsp">&block;&nbsp;&nbsp;SBS Drama</a></li>
                    <li><a href="/reviewboard/revList.jsp">&block;&nbsp;&nbsp;TVN Drama</a></li>
                    <li><a href="/reviewboard/revList.jsp">&block;&nbsp;&nbsp;JTBC Drama</a></li>
                </ul>
            </div>

            <div class="col-sm-9 row">
                    <!-- i=0 인데 i가 dblists.size보다 작을때 까지 반복 size=총게시물 -->
                <%for (int i = 0; i < dblists.size(); i++) { %>
                    <div style="width: 150px; height: 150px; margin: 20px;">
                     <div class="thumbnail bootsnipp-thumb" style="padding:0;">
                        <div class="imgwrap" style="height: 100px;">
                            <a href="dramaView.jsp?bdno=<%=dblists.get(i).getBdno()%>">
                                <img class="danlazy"
                                     src="showimg.jsp?f=<%=dblists.get(i).getFile1()%>"
                                     width="100%" height="100%">
                            </a>
                        </div>



                        <%--제목,날짜,조회수 표시할 부분--%>
                        <div style="width: 150px;">
                            <div>
                                <span class="text-left"
                                      style="overflow: hidden ; text-overflow: ellipsis; white-space: nowrap;  width: 150px; height: auto; display: inline-block;  ">
                                    <%--게시글 상세보기로 넘어가는 링크작성--%>
                                    <a href="dramaView.jsp?bdno="></a>
                                </span>
                            </div>
                            <div class="text-leftx" style="font-size: 10pt">
                                <span></span>
                                <span> </span>
                                <span></span>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>

        <%--검색창--%>
        <form name="revlist" method="post" action="dramalist.jsp">
            <div align="center">
                <table>
                    <tr>
                        <td width="70%" align="center">&nbsp;&nbsp;
                            <select name="colname" class="txt">
                                <option value="selected" selected>검색</option>
                                <option value="title">제목</option>
                                <option value="contents">본문</option>
                                <option value="userid">글쓴이</option>
                            </select>

                            <input name="findtext" type="text"/>

                            <button type="submit" id="findbtn" class="btn btn-primary ">검색</button>
                        </td>
                    </tr>
                </table>
            </div>
        </form>

        <div class="row" style="margin: 10px 30px 20px 30px">
            <!--페이지네이션-->
            <div class="col-12">
                <nav aria-label="Page navigation example">
                    <ul class="pagination justify-content-center">
                        <li class="page-item">
                            <a class="page-link" href="#" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                                <span class="sr-only">Previous</span>
                            </a>
                        </li>
                        <li class="page-item"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                        <li class="page-item">
                            <a class="page-link" href="#" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                                <span class="sr-only">Next</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

</div>

<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
        integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
        crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
        integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
        crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
        integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
        crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="../js/loginfrm.js"></script>

<script>
    // 상단 로그인 버튼
    $(function () {
        $('#mloginbtn').on('click', function (e) {
            location.href = '/ttpro/login/login.jsp';
        });
    });
    // 회원가입 버튼
    $(function () {
        $('#joinbtn').on('click', function (e) {
            location.href = '/ttpro/signup/signagree.jsp';
        });
    });

    $(function () {
        $('#newbtn').on('click', function (e) {
            location.href = '/ttpro/dogboard/dogWrite.jsp';
        });
    });
</script>

</body>
</html>