import { Component } from '@angular/core';
import { Author } from 'src/interfaces/Author';
import { Category } from 'src/interfaces/Category';
import { Supplier } from 'src/interfaces/Supplier';
import { AuthorsService } from 'src/services/Authors/authors.service';
import { CategoriesService } from 'src/services/Categories/categories.service';
import { SupliersService } from 'src/services/Supliers/supliers.service';
import { BooksService } from 'src/services/Books/books.service';
import { bookhome } from 'src/interfaces/bookhome';
import { Cloudinary } from '@cloudinary/url-gen';
import { BookDetailsService } from 'src/services/BookDetails/bookdetails.service';
import { BookImgsService } from 'src/services/BookImgs/bookimgs.service';
import { BookDetail} from  'src/interfaces/bookdetail';
import { bookimg } from 'src/interfaces/bookimg';
@Component({
  selector: 'app-them-sach',
  templateUrl: './them-sach.component.html',
  styleUrls: ['./them-sach.component.css'],
})
export class ThemSachComponent {
  constructor(private authors: AuthorsService, private categories: CategoriesService,
     private suppliers: SupliersService, private booksservice:BooksService
     ,private bookimgservice:BookImgsService,private bookDetailservice:BookDetailsService) {}
  Authors: Author[]=[];
  Categories: Category[]=[];
  Suppliers: Supplier[]=[];
  Books:any = {}
  BookDetail:any = {}
  BookImg:any = {}
  selectedAuthor: any = {};
  selectedCategory: any = {};
  selectedSupplier: any = {};
  BookDataForm: any = {};
  BookCount: any;
  checkdetail:boolean=false;
  checkimge:boolean=false;
  ngOnInit()
  {
    this.authors.Authors().subscribe({
      next: (res) => {
        this.Authors = res
      },
      error: (err) => {
        console.error('Lỗi lấy dữ liệu ', err)
      }
    });
    this.categories.Categories().subscribe({
      next: (res) => {
          this.Categories = res;
      },
      error: (err) => {
          console.error('Lỗi lấy dữ liệu ', err);
      }
    });
    this.suppliers.Suppliers().subscribe({
      next: (res) => {
        this.Suppliers = res
      },
      error: (err) => {
        console.error('Lỗi lấy dữ liệu ', err)
      }
    });
    this.booksservice.countBook().subscribe({
      next: res => {
        this.BookCount = 'B'+(res*1+1*1);
      },
      error: err => {
        console.log('Lỗi lấy dữ liệu: ', err);
      }
    });
    const cld = new Cloudinary({cloud: {cloudName: 'ddlsouigc'}});
  }
  postBook()
  {
    console.log(this.selectedAuthor)
    const bookData = {
      id: this.BookCount,
      title: this.Books.title,
      authorId: this.selectedAuthor,
      supplierId: this.selectedSupplier,
      unitPrice: this.Books.unitPrice,
      pricePercent: this.Books.pricePercent,
      publishYear: this.Books.yearSX,
      available: true,
      quantity: this.Books.quantity,
      author: null,
      supplier: null,
      bookdetail: null,
      bookimg: null,
      carts: [],
      orders: [],
      productReviews: []
    };
    const databookimg =
    {
    bookId: this.BookCount,
    image0: "assets/productImg/B1002-0.jpg",
    image1: "assets/productImg/B1002-1.jpg",
    image2: "assets/productImg/B1002-2.jpg",
    image3: "assets/productImg/B1002-3.jpg",
    }
    const datadatailbook=
    {
      bookId: this.BookCount,
      categoryId:this.selectedCategory,
      dimensions:this.BookDetail.dimensions,
      pages: this.BookDetail.number,
      description: this.BookDetail.description,
    }
    console.log(bookData,databookimg,datadatailbook)

    this.booksservice.postBook(bookData).subscribe({
      next: (res) => {
        this.bookimgservice.addimage(databookimg).subscribe({
          next: (res) => {
            this.checkimge=true;
          },
          error: (err) => {
            console.error('Lỗi lấy dữ liệu ', err)
          }
        });
        this.bookDetailservice.addBookDetail(datadatailbook).subscribe({
          next: (res) => {
            this.checkdetail=true
          },
          error: (err) => {
            console.error('Lỗi lấy dữ liệu ', err)
          }
        });
        if(this.checkdetail&&this.checkimge)
    {
      alert('Thêm sách thành công')
    }
      },
      error: (err) => {
        console.error('Lỗi lấy dữ liệu ', err)
      }
    });

  }
}
